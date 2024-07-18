extends RigidBody2D
# InspectorStuff
@export_range (0.0, 1.0) var fillPercent : float
@export var maxFillShrinkAmount : Vector2 = Vector2(0,2)
@export var minFillShrinkAmount : Vector2 = Vector2(0,4)
#references
@onready var reference_rect = $ReferenceRect
@onready var fluid = $FluidMask/Fluid
@onready var max_fill = $MaxFill
@onready var min_fill = $MinFill
#hidden
var potionHeight
var potionWidth


# Called when the node enters the scene tree for the first time.
func _ready():
	potionHeight = reference_rect.get_rect().size.y
	potionWidth = reference_rect.get_rect().size.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fluid.global_rotation = 0
	angular_velocity = 7
	
	var rotHeight : Vector2 = get_rotated_height()
	rotHeight = rotHeight.normalized()
	var shrinkPercent = abs(rotHeight.x) * abs(rotHeight.x) # accounts for rotated potion x-component 
	var maxHeightOffset = maxFillShrinkAmount * shrinkPercent
	var minHeightOffset = minFillShrinkAmount * shrinkPercent
	var adjustedMaxFill : Vector2 = max_fill.position + maxHeightOffset
	var adjustMinFill : Vector2  = min_fill.position - minHeightOffset
	
	fluid.global_position = global_position
	fluid.global_position += adjustedMaxFill.lerp(adjustMinFill, 1-fillPercent)
	
	pass


func get_rotated_height() -> Vector2:
	return (Vector2.RIGHT * potionHeight).rotated(global_rotation)
