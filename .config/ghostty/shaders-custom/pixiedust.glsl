// Pixiedust Cursor Effect for Ghostty
// Inspired by Neovide's pixiedust VFX mode
// Creates sparkling particles that trail behind the cursor

// Configuration parameters
#define PARTICLE_COUNT 50.0
#define PARTICLE_SIZE 1.5
#define PARTICLE_LIFETIME 2.0
#define SPARKLE_INTENSITY 0.8
#define TRAIL_LENGTH 0.3
#define GLITTER_SPEED 3.0

// Pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Hash function for better randomness
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

// Noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Create star-like particle
float star(vec2 uv, float size) {
    uv = abs(uv);
    vec2 star = vec2(0.0);
    star.x = max(uv.x * 0.866 + uv.y * 0.5, uv.y) / size;
    star.y = max(uv.x * 0.866 - uv.y * 0.5, uv.y) / size;
    float r = max(star.x, star.y);
    return max(0.0, 1.0 - r);
}

// Simulate cursor movement trail with particles
vec3 pixiedustEffect(vec2 fragCoord, vec2 cursorPos) {
    vec3 color = vec3(0.0);
    vec2 resolution = iResolution.xy;
    vec2 uv = fragCoord / resolution;

    // Normalize cursor position
    vec2 normalizedCursor = cursorPos / resolution;

    // Create animated cursor trail
    float time = iTime;

    for (float i = 0.0; i < PARTICLE_COUNT; i++) {
        // Create pseudo-random offset for each particle
        float particleId = i / PARTICLE_COUNT;
        float timeOffset = hash(i * 12.34) * 6.28;
        float sizeVariation = 0.5 + 0.5 * hash(i * 45.67);

        // Simulate particle trailing behind cursor with some delay
        float delay = particleId * TRAIL_LENGTH;
        float particleTime = time + timeOffset - delay;

        // Create spiraling motion around cursor path
        vec2 spiralOffset = vec2(
            cos(particleTime * GLITTER_SPEED + timeOffset) * 0.02,
            sin(particleTime * GLITTER_SPEED + timeOffset) * 0.02
        );

        // Add some randomness to particle positions
        vec2 randomOffset = vec2(
            noise(vec2(i * 0.1, time * 0.5)) - 0.5,
            noise(vec2(i * 0.1 + 100.0, time * 0.5)) - 0.5
        ) * 0.01;

        // Calculate particle position near cursor
        vec2 particlePos = normalizedCursor + spiralOffset + randomOffset;

        // Distance from current fragment to particle
        float dist = distance(uv, particlePos);

        // Particle fade based on time and distance from cursor
        float fadeFromCursor = 1.0 - smoothstep(0.0, 0.1, distance(normalizedCursor, particlePos));
        float timeFade = sin(particleTime * 2.0) * 0.5 + 0.5;
        float alpha = fadeFromCursor * timeFade * SPARKLE_INTENSITY;

        // Create star-shaped particles
        vec2 particleUV = (uv - particlePos) * resolution.y;
        float starShape = star(particleUV, PARTICLE_SIZE * sizeVariation);

        // Color variation - create rainbow-like pixiedust
        vec3 particleColor = vec3(
            0.5 + 0.5 * sin(particleTime + timeOffset),
            0.5 + 0.5 * sin(particleTime + timeOffset + 2.094),
            0.5 + 0.5 * sin(particleTime + timeOffset + 4.188)
        );

        // Add some golden/white sparkle
        particleColor = mix(particleColor, vec3(1.0, 0.9, 0.7), 0.3);

        // Apply particle to final color
        color += particleColor * starShape * alpha;
    }

    return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Get the original terminal content
    vec4 originalColor = texture(iChannel0, fragCoord / iResolution.xy);

    // For now, we simulate cursor position since cursor uniforms may not be available
    // In newer versions of Ghostty with cursor uniforms, replace this with:
    // vec2 cursorPos = iCursorPos;

    // Simulate cursor movement for demonstration
    vec2 center = iResolution.xy * 0.5;
    vec2 cursorPos = center + vec2(
        sin(iTime * 1.5) * 200.0,
        cos(iTime * 0.8) * 150.0
    );

    // If cursor uniforms are available, uncomment this line:
    // vec2 cursorPos = iCursorPos;

    // Generate pixiedust effect
    vec3 pixiedust = pixiedustEffect(fragCoord, cursorPos);

    // Blend pixiedust with original terminal content
    vec3 finalColor = originalColor.rgb + pixiedust;

    fragColor = vec4(finalColor, originalColor.a);
}
