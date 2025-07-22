// Smooth Cursor Smear Animation for Ghostty
// Replicates Neovide's smooth cursor movement effect
// Creates a smear trail that shows cursor transitioning from old to new position

// Configuration
#define SMEAR_LENGTH 0.15    // Length of the smear trail (0.0 to 1.0)
#define SMEAR_OPACITY 0.7    // Opacity of the smear effect
#define ANIMATION_SPEED 8.0  // Speed of cursor animation
#define CURSOR_WIDTH 8.0     // Cursor width in pixels
#define CURSOR_HEIGHT 16.0   // Cursor height in pixels

// Simple easing function for smooth animation
float easeOutQuart(float t) {
    return 1.0 - pow(1.0 - t, 4.0);
}

// Create a rectangular cursor shape
float cursorShape(vec2 pos, vec2 cursorPos, vec2 size) {
    vec2 d = abs(pos - cursorPos) - size * 0.5;
    return 1.0 - smoothstep(0.0, 1.0, max(d.x, d.y));
}

// Simulate cursor movement for now (replace with actual cursor tracking when available)
vec2 getCursorPosition() {
    // Simulate smooth cursor movement
    vec2 center = iResolution.xy * 0.5;
    float t = iTime * 0.5;

    // Create a path that demonstrates the smear effect
    vec2 offset = vec2(
        sin(t) * 150.0 + sin(t * 2.3) * 50.0,
        cos(t * 0.7) * 100.0 + sin(t * 1.8) * 30.0
    );

    return center + offset;
}

// Get interpolated cursor position for smear effect
vec2 getSmearPosition(float offset) {
    float time = iTime - offset * SMEAR_LENGTH;
    vec2 center = iResolution.xy * 0.5;
    float t = time * 0.5;

    vec2 offsetPos = vec2(
        sin(t) * 150.0 + sin(t * 2.3) * 50.0,
        cos(t * 0.7) * 100.0 + sin(t * 1.8) * 30.0
    );

    return center + offsetPos;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Get original terminal content
    vec4 originalColor = texture(iChannel0, fragCoord / iResolution.xy);

    // Current cursor position
    vec2 currentCursor = getCursorPosition();

    // Initialize cursor effect
    float cursorEffect = 0.0;
    vec3 cursorColor = vec3(1.0); // White cursor by default

    // Create cursor smear trail
    const int SMEAR_SAMPLES = 12;
    for (int i = 0; i < SMEAR_SAMPLES; i++) {
        float t = float(i) / float(SMEAR_SAMPLES - 1);

        // Get position along the smear trail
        vec2 smearPos = getSmearPosition(t * SMEAR_LENGTH);

        // Calculate cursor shape at this position
        float cursor = cursorShape(fragCoord, smearPos, vec2(CURSOR_WIDTH, CURSOR_HEIGHT));

        // Apply fade along the trail
        float fade = 1.0 - easeOutQuart(t);
        fade *= SMEAR_OPACITY;

        // Accumulate cursor effect
        cursorEffect = max(cursorEffect, cursor * fade);
    }

    // Main cursor at current position (full opacity)
    float mainCursor = cursorShape(fragCoord, currentCursor, vec2(CURSOR_WIDTH, CURSOR_HEIGHT));
    cursorEffect = max(cursorEffect, mainCursor);

    // Sample the color under the cursor for blending
    vec2 cursorUV = currentCursor / iResolution.xy;
    vec3 underCursorColor = texture(iChannel0, cursorUV).rgb;

    // Invert the color under cursor for visibility
    vec3 invertedColor = vec3(1.0) - underCursorColor;

    // Blend cursor with original content
    vec3 finalColor = mix(originalColor.rgb, invertedColor, cursorEffect);

    fragColor = vec4(finalColor, originalColor.a);
}
