shader_type canvas_item;

uniform float height : hint_range(0.0, 20.0) = 3.0;
uniform float frequency : hint_range(0.0, 100.0) = 20.0;
uniform float speed : hint_range(0.0, 10.0) = 3.0;

void vertex() {
    // Only apply the wave effect to the upper part of the sprite
    VERTEX.y += height * sin((frequency * UV.x) + (speed * TIME));
}
