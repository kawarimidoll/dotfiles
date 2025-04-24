// ref: https://github.com/hackr-sh/ghostty-shaders/blob/main/gradient-background.glsl

// Function to convert hex color to vec3
vec3 hexToRgbVec3(int hexColor) {
  float r = float((hexColor >> 16) & 0xFF) / 255.0;
  float g = float((hexColor >> 8) & 0xFF) / 255.0;
  float b = float(hexColor & 0xFF) / 255.0;
  return vec3(r, g, b);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalize pixel coordinates (range from 0 to 1)
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Create a vertical gradient
    float gradientFactor = uv.y / 2.0;

    // Define gradient colors
    // for dark mode
    // vec3 gradientStartColor = vec3(0.1, 0.1, 0.5);
    // vec3 gradientEndColor = vec3(0.5, 0.1, 0.1);
    // for light mode
    int baseColor = 0xf8f8ff;
    vec3 terminalBgColor = hexToRgbVec3(baseColor);
    vec3 gradientStartColor = terminalBgColor;
    vec3 gradientEndColor = hexToRgbVec3(0xe1fae9);

    vec3 gradientColor = mix(gradientStartColor, gradientEndColor, gradientFactor);

    // Sample the terminal screen texture including alpha channel
    vec4 terminalColor = texture(iChannel0, uv);

    // Make a mask to determine whether to use gradientColor or terminalColor
    // If the terminal color is close to the terminal bg color, use the gradient color
    float mask = distance(terminalColor.rgb, terminalBgColor) * 255.0 < 1.0 ? 1.0 : 0.0;
    vec3 blendedColor = mix(terminalColor.rgb, gradientColor, mask);

    // 色を線形補間する
    // tは0.0(完全にcolor0) ~ 1.0(完全にcolor1)
    // mix(color0, color1, t)

    // Apply terminal's alpha to control overall opacity
    fragColor = vec4(blendedColor, terminalColor.a);
}
