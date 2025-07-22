// Smooth Cursor Animation Shader for Ghostty
// Provides smooth cursor movement and subtle animations without trails
// Similar to VS Code's smooth caret animation

// Smooth easing function for natural movement
float easeInOutCubic(float t) {
    return t < 0.5 ? 4.0 * t * t * t : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
}

// Smooth step function with better curve
float smootherstep(float edge0, float edge1, float x) {
    x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    return x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
}

// Normalize coordinates to -1 to 1 range
vec2 normalizeCoord(vec2 coord, float isPosition) {
    return (coord * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

// Distance function for rounded rectangle (smoother than sharp edges)
float roundedBoxSDF(vec2 centerPosition, vec2 size, float radius) {
    return length(max(abs(centerPosition) - size + radius, 0.0)) - radius;
}

// Subtle glow effect
float glow(float d, float strength, float size) {
    return strength / (1.0 + d * d * size);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Get the original terminal content
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);

    // Normalize fragment coordinate
    vec2 uv = normalizeCoord(fragCoord, 1.0);

    // Normalize cursor data
    vec4 currentCursor = vec4(
        normalizeCoord(iCurrentCursor.xy, 1.0),
        normalizeCoord(iCurrentCursor.zw, 0.0)
    );
    vec4 previousCursor = vec4(
        normalizeCoord(iPreviousCursor.xy, 1.0),
        normalizeCoord(iPreviousCursor.zw, 0.0)
    );

    // Animation timing
    float timeSinceChange = iTime - iTimeCursorChange;
    float animationDuration = 0.15; // Quick, smooth animation
    float progress = clamp(timeSinceChange / animationDuration, 0.0, 1.0);

    // Apply smooth easing
    float easedProgress = easeInOutCubic(progress);

    // Interpolate cursor position smoothly
    vec2 smoothCursorPos = mix(previousCursor.xy, currentCursor.xy, easedProgress);
    vec2 smoothCursorSize = mix(previousCursor.zw, currentCursor.zw, easedProgress);

    // Calculate cursor center for positioning
    vec2 cursorCenter = smoothCursorPos - vec2(-0.5, 0.5) * smoothCursorSize;

    // Distance to cursor center
    vec2 toCursor = uv - cursorCenter;

    // Create rounded rectangle for smoother appearance
    float cursorRadius = min(smoothCursorSize.x, smoothCursorSize.y) * 0.1;
    float cursorDist = roundedBoxSDF(toCursor, smoothCursorSize * 0.5, cursorRadius);

    // Sample the original color under the cursor
    vec3 originalColor = fragColor.rgb;

    // Calculate luminance to determine if we should use light or dark text
    float luminance = dot(originalColor, vec3(0.299, 0.587, 0.114));

    // Cursor background colors
    vec3 lightCursorBg = vec3(0.9, 0.9, 0.9);   // Light gray background
    vec3 darkCursorBg = vec3(0.2, 0.2, 0.2);    // Dark gray background
    vec3 glowColor = vec3(0.6, 0.8, 1.0);       // Subtle blue glow

    // Choose cursor background based on content brightness
    vec3 cursorBgColor = luminance > 0.5 ? darkCursorBg : lightCursorBg;

    // Choose text color that contrasts with background
    vec3 cursorTextColor = luminance > 0.5 ? vec3(1.0) : vec3(0.0);

    // Smooth cursor edge with anti-aliasing
    float cursorMask = 1.0 - smootherstep(-0.002, 0.002, cursorDist);

    // Subtle glow effect during movement
    float movementGlow = glow(length(toCursor), 0.3 * (1.0 - easedProgress), 50.0);

    // Breathing effect for stationary cursor (very subtle)
    float breathe = 0.95 + 0.05 * sin(iTime * 2.0);
    float stationaryTime = clamp((timeSinceChange - 0.5) / 0.5, 0.0, 1.0);

    // Apply breathing to cursor background
    vec3 finalCursorBg = cursorBgColor * breathe;

    // Create readable cursor: background + inverted/contrasted text
    vec3 readableCursor = mix(originalColor, cursorTextColor, cursorMask * 0.9) +
                         finalCursorBg * cursorMask * 0.8;

    // Add subtle glow during movement
    vec3 glowEffect = glowColor * movementGlow * (1.0 - easedProgress);

    // Blend readable cursor onto the terminal content
    fragColor.rgb = mix(fragColor.rgb, readableCursor, cursorMask);
    fragColor.rgb += glowEffect * 0.005; // Subtle glow
}
