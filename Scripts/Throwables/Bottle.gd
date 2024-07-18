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
var target : Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	potionHeight = reference_rect.get_rect().size.y
	potionWidth = reference_rect.get_rect().size.x
	angular_velocity = 15
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fluid.global_rotation = 0
	angular_velocity = lerp(angular_velocity, 0.0, 0.2 * delta)
	var rotHeight : Vector2 = get_rotated_height()
	rotHeight = rotHeight.normalized()
	var shrinkPercent = abs(rotHeight.x) # accounts for rotated potion x-component 
	var normalized_angle = wrapf(global_rotation, 0, 2 * PI)
	# Use the y-component for height adjustment when the bottle is upside down
	if normalized_angle > PI / 2 and normalized_angle < 3 * PI / 2:
		shrinkPercent = 1.0 - shrinkPercent
	
	var maxHeightOffset = maxFillShrinkAmount * shrinkPercent
	var minHeightOffset = minFillShrinkAmount * shrinkPercent
	var adjustedMaxFill: Vector2 = max_fill.position + maxHeightOffset
	var adjustMinFill: Vector2 = min_fill.position - minHeightOffset

	fluid.global_position = global_position
	# fluid.global_position += adjustedMaxFill.lerp(adjustMinFill, 1 - fillPercent)
	
	if normalized_angle > PI / 2 and normalized_angle < 3 * PI / 2:
		target = target.lerp(adjustedMaxFill.lerp(adjustedMaxFill*1.45, 1 - fillPercent), delta * 4)
	else:
		target = target.lerp(adjustedMaxFill.lerp(adjustMinFill, 1 - fillPercent), delta * 4)
	fluid.global_position += target
	pass


func get_rotated_height() -> Vector2:
	return (Vector2.UP * potionHeight).rotated(global_rotation)
