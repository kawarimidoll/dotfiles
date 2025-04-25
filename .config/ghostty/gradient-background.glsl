// Gradient Background Shader for Ghostty
// ref: https://github.com/hackr-sh/ghostty-shaders/blob/main/gradient-background.glsl

// ======================
// User-defined colors

// Terminal background color
// This color can be checked with: `ghostty +show-config | grep ^background`
int terminalBgColorHex = 0xf8f8ff;

// Gradient start color
int gradientStartColorHex = terminalBgColorHex;

// Gradient end color
int gradientEndColorHex = 0xebfaf5;
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

    vec3 gradientColor = calculatePixelColor(uv);
    fragColor = vec4(gradientColor, terminalColor.a);
}

// Helper to convert hex color to RGB vector
vec3 hexToRgbVec3(int hexColor) {
    float r = float((hexColor >> 16) & 0xFF) / 255.0;
    float g = float((hexColor >> 8) & 0xFF) / 255.0;
    float b = float(hexColor & 0xFF) / 255.0;
    return vec3(r, g, b);
}

// Function to calculate pixel color based on UV coordinates
vec3 calculatePixelColor(vec2 uv) {
    // Create a vertical gradient
    float gradientFactor = uv.y;

    vec3 gradientStartColor = hexToRgbVec3(gradientStartColorHex);
    vec3 gradientEndColor = hexToRgbVec3(gradientEndColorHex);

    // `mix` is a function to interpolate between two colors.
    // The mix function takes two colors and a factor t.
    //   mix(color0, color1, t)
    // `t` ranges from 0.0 (completely `color0`) to 1.0 (completely `color1`).
    return mix(gradientStartColor, gradientEndColor, gradientFactor);
}
