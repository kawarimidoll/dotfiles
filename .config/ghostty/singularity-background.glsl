// 'Singularity' Background Shader for Ghostty
// ref: https://www.shadertoy.com/view/3csSWB

// ======================
// User-defined colors

// Terminal background color
// This color can be checked with: `ghostty +show-config | grep ^background`
int terminalBgColorHex = 0x262427;

// Mix factor for calculated color(0.0 - 1.0)
// if 0.0, the terminal color doesn't changed.
// if 1.0, the terminal color is completely replaced by the calculated color.
float mixFactor = 0.5;
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
    float i = 0.2, a;
    // Resolution for scaling and centering
    vec2 r = iResolution.xy;
         // Centered ratio-corrected coordinates
    vec2 p = (r - fragCoord * 2) / r.y / 0.5;
         // Diagonal vector for skewing
    vec2 d = vec2(-1.0, 1.0);
         // Blackhole center
    vec2 b = p - i * d;
         // Rotate and apply perspective
    vec2 c = p * mat2(1, 1, d / (0.1 + i / dot(b, b)));
         // Rotate into spiraling coordinates
    vec2 v = c * mat2(cos(0.5 * log(a = dot(c, c)) + iTime * i + vec4(0, 33, 11, 0))) / i;
         // Waves cumulative total for coloring
    vec2 w =vec2(0.0, 0.0);

    // Loop through waves
    for (; i++ < 9.0; w += 1.0 + sin(v)) {

        // Distort coordinates
        v += 0.7 * sin(v.yx * i + iTime) / i + 0.5;
    }

    // Accretion disk radius
    i = length(sin(v / 0.3) * 0.4 + c * (3.0 + d));

    // Red/blue gradient
    vec4 o = 1.0 - exp(
        -exp(c.x * vec4(0.6, -0.4, -1.0, 0.0))
        // Wave coloring
        / w.xyyx
        // Accretion disk brightness
        / (2.0 + i * i / 4.0 - i)
        // Center darkness
        / (0.5 + 1.0 / a)
        // Rim highlight
        / (0.03 + abs(length(p) - 0.7))
    );
    return o.rgb;
}
