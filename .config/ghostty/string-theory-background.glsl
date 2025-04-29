// 'String Theory' Background Shader for Ghostty
// ref: https://www.shadertoy.com/view/33sSzf
// original: https://x.com/XorDev/status/1914698293554139442

// ======================
// User-defined colors

// Mix factor for calculated color(0.0 - 1.0)
// if 0.0, the terminal color doesn't changed.
// if 1.0, the terminal color is completely replaced by the calculated color.
float mixFactor = 0.05;
// ======================

// Function to calculate pixel color based on fragCoord and isLightMode
vec3 calculatePixelColor(in vec2 fragCoord, bool isLightMode);

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalize pixel coordinates to range [0, 1]
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Assume that the color at (0, 0) is the background color
    vec3 terminalBgColor = (texture(iChannel0, vec2(0.0))).rgb;

    // Sample the terminal screen texture at the current pixel coordinates
    vec4 terminalColor = texture(iChannel0, uv);

    // Compare the sampled color with the background color
    // if they match, treat the current pixel as background
    bool isBackground = all(equal(terminalColor.rgb, terminalBgColor));

    // If the current pixel is NOT background (e.g., text), use its color directly without blending
    if (!isBackground) {
        fragColor = terminalColor;
        return;
    }

    // Simple calculation: if the average of RGB exceeds 127, treat as light mode
    bool isLightMode = dot(terminalBgColor.rgb, vec3(1.0)) > (0.5 * 3);

    vec3 calculatedColor = calculatePixelColor(fragCoord, isLightMode);
    vec3 resultColor = mix(terminalColor.rgb, calculatedColor, mixFactor);
    fragColor = vec4(resultColor, terminalColor.a);
}

// Function to calculate pixel color based on fragCoord and isLightMode
vec3 calculatePixelColor(in vec2 fragCoord, bool isLightMode) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec3 r = vec3(uv, 1.0);
    vec4 o = vec4(0.0);
    float t = iTime;
    vec3 p;

    for (float i = 0.0, z = 0.0, d; i < 100.0; i++) {
        // Ray direction, modulated by time and camera
        p = z * normalize(vec3(uv, 0.5));
        p.z += t;

        // Rotating plane using a cos matrix
        vec4 angle = vec4(0.0, 33.0, 11.0, 0.0);
        vec4 a = z * 0.2 + t * 0.1 + angle;
        p.xy *= mat2(cos(a.x), -sin(a.x), sin(a.x), cos(a.x));

        // Distance estimator
        z += d = length(cos(p + cos(p.yzx + p.z - t * 0.2)).xy) / 6.0;

        // Color accumulation using sin palette
        o += (sin(p.x + t + vec4(0.0, 2.0, 3.0, 0.0)) + 1.0) / d;
    }

    o = tanh(o / 5000.0);

    if (isLightMode) {
        // Invert the calculated color if the terminal background is in light mode
        o = 1.0 - o;
    }
    return o.rgb;
}
