shader_type canvas_item;

uniform float border_thickness = 4.0; // Thickness of the right border in pixels
uniform vec4 border_color = vec4(1.0, 0.0, 0.0, 1.0); // Color of the right border (Red)

void fragment() {
    // Use SCREEN_PIXEL_SIZE to calculate border thickness in UV space
    float right_border_limit = 1.0 - (border_thickness * SCREEN_PIXEL_SIZE.x);

    // If the fragment lies within the right border area, color it
    if (UV.x > right_border_limit) {
        COLOR = border_color; // Draw the right border
    } else {
        discard; // Make everything else transparent
    }
}
