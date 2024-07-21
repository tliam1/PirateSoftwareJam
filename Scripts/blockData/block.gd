extends Node2D

@onready var spr = $RigidBody2D/Sprite2D
@onready var polygonCol = $RigidBody2D/CollisionPolygon2D
@onready var rb : RigidBody2D = $RigidBody2D


var original_polygon_points = []
var childrenScale : Vector2 = Vector2(1.0, 1.0)
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

func SetScale(newScale : float):
	print(str(self) + " was given new scale")
	childrenScale += Vector2(newScale, newScale)
#	spr.scale = newScale
#	polygonCol.scale = newScale
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	moveToNewScale(delta)
	pass

func moveToNewScale(delta):
	if(spr.scale != childrenScale):
		spr.scale = spr.scale.move_toward(childrenScale, delta * 3)
		polygonCol.scale = spr.scale
		polygonCol.position = Vector2.ZERO - (spr.texture.get_size()*childrenScale.x)/2

func AddForces(dir : Vector2, speed : float):
	rb.apply_impulse(dir * speed) # can add position too
	pass

func Remove():
	call_deferred("queue_free")
