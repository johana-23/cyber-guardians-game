shader_type canvas_item;

uniform float time; // For animating the stars (twinkle)

void fragment() {
    vec2 uv = UV;

    // Background color (keep #082c50)
    vec4 base_color = vec4(0.031, 0.173, 0.314, 1.0); // #082c50 in normalized RGB

    // Generate pseudo-random star field based on UV
    float star_field = fract(sin(dot(uv * vec2(100.0, 100.0), vec2(12.9898, 78.233))) * 43758.5453);

    // Create even fewer bright stars (increase threshold further)
    float stars = step(0.998, star_field); // Very high threshold for fewer stars

    // Add a slight twinkle effect
    stars *= sin(time * 5.0 + uv.x * 10.0) * 0.5 + 0.5; // Twinkling

    // Combine the stars (white dots) with the background color
    vec4 star_color = vec4(1.0, 1.0, 1.0, 1.0) * stars; // White stars

    // Final color: background + stars
    COLOR = base_color + star_color;
}
