shader_type canvas_item;

void fragment() {
    vec2 uv = UV;

    // Base color
    vec4 base_color = vec4(0.031, 0.173, 0.314, 1.0); // #082c50

    // Moving wave pattern
    float wave_pattern = sin(uv.y * 10.0 + TIME * 2.0) * 0.5 + 0.5;

    // Combine with gradient
    float light_intensity = wave_pattern * smoothstep(0.0, 1.0, uv.y);

    // Light and shadow
    vec4 light_color = vec4(0.1, 0.3, 0.5, 0.4) * light_intensity;
    vec4 shadow_color = vec4(0.0, 0.0, 0.0, 0.4) * (1.0 - light_intensity);

    COLOR = base_color - shadow_color + light_color;
}
