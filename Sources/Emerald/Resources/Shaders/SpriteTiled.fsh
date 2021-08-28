//uniform vec2 u_tiling;
//uniform vec2 u_offset;

void main() {
    vec2 uv = v_tex_coord.xy + u_offset;
    vec2 phase = fract(uv / u_tiling);
    vec4 current_color = texture2D(u_texture, phase);

    gl_FragColor = current_color;
}
