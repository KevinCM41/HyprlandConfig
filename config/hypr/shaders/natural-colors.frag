#version 320 es

precision mediump float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);
    
    // Reduce saturation
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(color.rgb, vec3(gray), 0.01);
    
    // Make blacks deeper
    color.rgb = pow(color.rgb, vec3(1.0));
    
    // Sharpen colors with slight contrast boost
    color.rgb = (color.rgb - 0.5) * 1.11 + 0.5;
    
    // Add slight sharpening effect
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(color.rgb, color.rgb + (color.rgb - vec3(luminance)) * 0.4, 0.8);
    
    // Slightly reduce overall brightness
    color.rgb *= 1.00;
    
    fragColor = color;
}