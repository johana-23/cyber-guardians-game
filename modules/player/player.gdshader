shader_type canvas_item;

uniform vec3 target_color1;
uniform vec3 target_color2;

uniform vec3 replacement_color1;
uniform vec3 replacement_color2;

uniform float tolerance;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float distance1 = length(tex_color.rgb - target_color1);
    float distance2 = length(tex_color.rgb - target_color2);

    if (distance1 < tolerance) {
        COLOR = vec4(replacement_color1, tex_color.a);
    } else if (distance2 < tolerance) {
        COLOR = vec4(replacement_color2, tex_color.a);
    } else {
        COLOR = tex_color;
    }
}
