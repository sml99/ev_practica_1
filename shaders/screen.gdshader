shader_type spatial;

uniform sampler2D monitor_feed : source_color;
uniform float brightness : hint_range(0.0, 2.0) = 1.2;
uniform float scan_lines : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    // Get surveillance feed
    vec3 feed_color = texture(monitor_feed, UV).rgb;
    
    // Brighten like a real monitor
    feed_color *= brightness;
    
    // Add scan line effect
    float line = sin(UV.y * 600.0) * scan_lines;
    feed_color -= vec3(line);
    
    ALBEDO = feed_color;
    EMISSION = feed_color * 0.3; // Make it glow slightly
}