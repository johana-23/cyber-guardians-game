shader_type canvas_item;
void fragment() {
    vec2 uv = UV;
    // Base color
    vec4 base_color = vec4(0.031, 0.173, 0.314, 1.0); // #082c50
    // Scrolling diagonal wave pattern
    float wave_pattern = sin((uv.x + uv.y + TIME * 0.1) * 8.0 + TIME * 1.2) * 0.5 + 0.5;
    // Dynamic radial gradient movement
    float radial_gradient = 1.0 - smoothstep(0.3, 1.0, length(uv - vec2(0.5 + sin(TIME * 0.5) * 0.1, 0.5 + cos(TIME * 0.5) * 0.1)));
    // Combine diagonal waves and radial gradient
    float light_intensity = wave_pattern * radial_gradient;
    // Light color
    vec4 light_color = vec4(0.1, 0.3, 0.5, 0.4) * light_intensity;
    // Shadow effect
    float shadow_intensity = 1.0 - light_intensity;
    vec4 shadow_color = vec4(0.0, 0.0, 0.0, 0.4) * shadow_intensity;
    // Combine base color with soft light and shadow
    COLOR = base_color - shadow_color + light_color;
}