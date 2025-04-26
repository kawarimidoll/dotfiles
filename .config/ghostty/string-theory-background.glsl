// 'String Theory' Background Shader for Ghostty
// ref: https://www.shadertoy.com/view/33sSzf
// original: https://x.com/XorDev/status/1914698293554139442

// ======================
// User-defined colors

// Terminal background color
// This color can be checked with: `ghostty +show-config | grep ^background`
int terminalBgColorHex = 0xf8f8ff;

// Mix factor for calculated color(0.0 - 1.0)
// if 0.0, the terminal color doesn't changed.
// if 1.0, the terminal color is completely replaced by the calculated color.
float mixFactor = 0.05;
// ======================

// Helper to convert hex color to RGB vector
vec3 hexToRgbVec3(int hexColor);

// Function to calculate pixel color based on UV coordinates
vec3 calculatePixelColor(vec2 uv);

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalize pixel coordinates (range from 0 to 1)
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Convert hex color to RGB vector
    vec3 terminalBgColor = hexToRgbVec3(terminalBgColorHex);

    // Sample the terminal screen texture including alpha channel
    vec4 terminalColor = texture(iChannel0, uv);

    // Check if the current pixel is background
    // HACK: Since colors are float values, equality cannot be determined directly.
    // Therefore, consider the colors the same if the distance is less than 1/255.
    bool isBackground = distance(terminalColor.rgb, terminalBgColor) * 255.0 < 1.0;

    if (!isBackground) {
      // If the pixel is NOT background, use the terminal color
      fragColor = terminalColor;
      return;
    }

    vec3 resultColor = mix(terminalColor.rgb, calculatePixelColor(fragCoord), mixFactor);
    fragColor = vec4(resultColor, terminalColor.a);
}

// Helper to convert hex color to RGB vector
vec3 hexToRgbVec3(int hexColor) {
    float r = float((hexColor >> 16) & 0xFF) / 255.0;
    float g = float((hexColor >> 8) & 0xFF) / 255.0;
    float b = float(hexColor & 0xFF) / 255.0;
    return vec3(r, g, b);
}

// Function to calculate pixel color based on UV coordinates
vec3 calculatePixelColor(in vec2 fragCoord) {
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
    o = 1.0 - o;
    return o.rgb;
}
