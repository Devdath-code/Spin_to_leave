shader_type canvas_item;
render_mode unshaded;

const float curvature = 100.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float scanline_intensity : hint_range(0.0, 1.0, 0.01) = 0.4;
uniform float scanlines_width : hint_range(0.0, 0.5) = 0.25;
uniform float brightness : hint_range(0.0, 3.0, 0.1) = 1.2;
uniform float chromatic_offset : hint_range(0.0, 0.01, 0.0001) = 0.002;
uniform float scan_speed : hint_range(0.0, 5.0, 0.1) = 1.0;
uniform vec2 resolution = vec2(1280.0, 720.0);

void fragment() {
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    
    // Curvature
    vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
    vec2 uv_offset = centered_uv.yx / curvature;
    vec2 warped_uv = centered_uv + centered_uv * uv_offset * uv_offset;
    vec3 cutoff = vec3(step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y), 1.0));
    vec2 final_uv = (warped_uv + 1.0) / 2.0;
    
    // Chromatic aberration
    vec3 color;
    color.r = textureLod(screen_texture, vec2(final_uv.x + chromatic_offset, final_uv.y), 0.0).r;
    color.g = textureLod(screen_texture, vec2(final_uv.x, final_uv.y), 0.0).g;
    color.b = textureLod(screen_texture, vec2(final_uv.x - chromatic_offset, final_uv.y), 0.0).b;
    
    // Static scanlines
    float scanlines = smoothstep(scanlines_width, scanlines_width + 0.5, abs(sin(final_uv.y * (resolution.y * 3.14159265))));
    color = mix(color, color * vec3(scanlines), scanline_intensity);
    
    // Moving scanline on top
    float moving_scan = smoothstep(0.0, 0.05, abs(fract(final_uv.y - TIME * scan_speed * 0.1) - 0.5) - 0.4);
    color *= 0.7 + 0.3 * moving_scan;
    
    // Slight green phosphor tint + brightness
    color *= vec3(0.95, 1.05, 0.95) * brightness;
    
    // Vignette
    vec3 vignette = vec3(length(pow(abs(centered_uv), vec2(4.0)) / 3.0));
    color -= vignette * 0.8;
    
    color *= cutoff;
    COLOR = vec4(color, 1.0);
}