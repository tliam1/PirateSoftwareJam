extends Node2D

@onready var spr = $RigidBody2D/Sprite2D
@onready var polygonCol = $RigidBody2D/CollisionPolygon2D
@onready var rb : RigidBody2D = $RigidBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	var image : Image
	image = spr.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, spr.texture.get_size()), 5)
	print(polys[0])
	polygonCol.polygon = polys[0]
	polygonCol.position -= spr.texture.get_size()/2
	# AddForces(Vector2(randf_range(-10,10),randf_range(-10,10)), 2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func AddForces(dir : Vector2, speed : float):
	rb.apply_impulse(dir * speed) # can add position too
	pass
