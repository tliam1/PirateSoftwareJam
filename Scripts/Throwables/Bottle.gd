extends Node2D

# InspectorStuff
@export_range (0.0, 1.0) var fillPercent : float
@export var maxFillShrinkAmount : Vector2 = Vector2(0,2)
@export var minFillShrinkAmount : Vector2 = Vector2(0,4)
@export_range(0.0, 1.0) var setChildrenScale : float 
#references
@onready var reference_rect = $RigidBody2D/ReferenceRect
@onready var fluid = $RigidBody2D/Bottle/FluidMask/Fluid
@onready var fluidHolder = $RigidBody2D/Bottle
@onready var col = $RigidBody2D/CollisionShape2D
@onready var max_fill = $RigidBody2D/MaxFill
@onready var min_fill = $RigidBody2D/MinFill
@onready var rb : RigidBody2D = $RigidBody2D
@onready var explosionArea : Area2D = $RigidBody2D/ExplosionArea
@onready var explosionCollider : CollisionShape2D = $RigidBody2D/ExplosionArea/CollisionShape2D


# @onready var anim = $AnimationPlayer
#hidden
var potionHeight
var potionWidth
var target : Vector2 = Vector2.ZERO
var explosionEffectBodies : Array = []
var potionEffectHandler : PotionEffects = PotionEffects.new()
var activePotionEffect : String
var gameManager : Node2D = null
# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager = get_tree().get_root().find_child("GameManager", true, false)
	potionHeight = reference_rect.get_rect().size.y
	potionWidth = reference_rect.get_rect().size.x
	SetScale()
	# angular_velocity = 15
	pass # Replace with function body.


func SetScale():
	col.scale *= setChildrenScale
	fluidHolder.scale *= setChildrenScale
	explosionArea.scale *= setChildrenScale
	pass


func InitializeForce(dir : Vector2, speed : float, potionEffect : String):
	rb.apply_impulse(dir * speed)
	rb.angular_velocity = randf_range(5,15) * sign(dir.x)
	activePotionEffect = potionEffect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fluid.global_rotation = 0
	# angular_velocity = lerp(angular_velocity, 0.0, 0.2 * delta)
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

	fluid.global_position = rb.global_position
	# fluid.global_position += adjustedMaxFill.lerp(adjustMinFill, 1 - fillPercent)
	
	if normalized_angle > PI / 2 and normalized_angle < 3 * PI / 2:
		target = target.lerp(adjustedMaxFill.lerp(adjustedMaxFill*1.45, 1 - fillPercent), delta * 4)
	else:
		target = target.lerp(adjustedMaxFill.lerp(adjustMinFill, 1 - fillPercent), delta * 4)
	fluid.global_position += target
	
	queue_redraw()
	pass


func get_rotated_height() -> Vector2:
	return (Vector2.UP * potionHeight).rotated(global_rotation)


func _on_explosion_area_body_entered(body):
	return
#	if(rb.get_contact_count() < 0):
#		return
#	if !explosionEffectBodies.has(body):
#		explosionEffectBodies.append(body)
#		# print("Entered" + str(body))
#	pass # Replace with function body.


func _on_explosion_area_body_exited(body):
	return
#	if(rb.get_contact_count() < 0):
#		return
#	if explosionEffectBodies.has(body):
#		explosionEffectBodies.erase(body)
#		# print("Exit " + str(body))
#
#	pass # Replace with function body.

func _draw():
	draw_circle(rb.position, explosionCollider.shape.radius, Color.RED)


func _on_rigid_body_2d_body_entered(body):
	#rb.contact_monitor = false
	rb.call_deferred("set_contact_monitor", false)
	# call_deferred("rb.set_contact_monitor", false)
	rb.max_contacts_reported = 0
	# explode!
	if activePotionEffect in potionEffectHandler.ActiveCallable:
		potionEffectHandler.SetExplosionPosition(rb.global_position)
		potionEffectHandler.InitializePlayer(gameManager.player)
		potionEffectHandler.SetRoot(get_tree().get_root())
		if(explosionArea.get_overlapping_bodies().size() > 1):
			potionEffectHandler.ActiveCallable[activePotionEffect].call(explosionArea.get_overlapping_bodies())
		else:
			potionEffectHandler.ActiveCallable[activePotionEffect].call([body])
		print(explosionArea.get_overlapping_bodies())
#	else:
		call_deferred("queue_free")
#		print("RAN ELSE TO FREE QUEUE")
