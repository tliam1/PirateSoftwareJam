class_name PotionEffects
extends Resource

@export var explosionForce : int = 10

var ActiveCallable : Dictionary = {
	"AttractBlocksToPlayerEffect": AttractBlocksToPlayerEffect,
	"ZeroGravityEffect": ZeroGravityEffect,
	"BlastEffect": BlastEffect,
	"TeleportationEffect": TeleportationEffect,
	"GravityShift": GravityShift,
	"ReverseGravityPotion": ReverseGravityPotion,
	"StickyPotion": StickyPotion,
	"SpawnBlockPotion": SpawnBlockPotion,
	"AreaDeleterPotion": AreaDeleterPotion,
	"GrowthEffectPotion": GrowthEffectPotion,
	"EarthquakeEffectPotion": EarthquakeEffectPotion,
	"MagnatismEffectPotion": MagnatismEffectPotion,
	"JumpBoostPotion": JumpBoostPotion,
	"SpeedUpPotion": SpeedUpPotion,
	"DashPotionEffect": DashPotionEffect,
	"MorphPotion": MorphPotion,
	"SlipperyPotion": SlipperyPotion,
	"JumpResetPotion": JumpResetPotion
}

var player : Node2D
var explosionPosition : Vector2 

func InitializePlayer(p : Node2D):
	player = p

func SetExplosionPosition(v : Vector2):
	explosionPosition = v

func AttractBlocksToPlayerEffect(listOfTargets : Array):
	for body in listOfTargets:
		var dir : Vector2 = (player.global_position - body.global_position).normalized()
		if body != player:
			body.apply_impulse(dir * explosionForce*25)
			print("APPLIED FORCES")
	pass # moves target to player

func ZeroGravityEffect(listOfTargets : Array): #
	pass # makes targets have zero gravity (adds some force to blocks)

func BlastEffect(listOfTargets : Array):
	for body in listOfTargets:
		var dir : Vector2 = (body.global_position - explosionPosition).normalized()
		if body == player:
			# Preferential scaling of the Y axis
			var x_scale = 0.5 # Scaling factor for X axis, between 0 and 1
			var y_scale = 1.5 # Scaling factor for Y axis, typically 1 or higher
			# Scale the direction vector
			var scaled_dir = Vector2(dir.x * x_scale, dir.y * y_scale)
			body.AddForces(scaled_dir, explosionForce*20)
		else:
			body.apply_impulse(dir * explosionForce)
	pass # causes a blast (blasts player and blocks)

func TeleportationEffect(listOfTargets : Array):
	player.global_position = explosionPosition
	pass # teleports player to contact position 

func GravityShift(listOfTargets : Array): # @TODO
	pass # Alters gravity by a modifier

func ReverseGravityPotion(player : RigidBody2D, gravity_scale : float, listOfTargets : Array):
	pass # flips gravity for a short amount of time

func StickyPotion(listOfTargets : Array):
	pass # makes the player stick to things
	
func SpawnBlockPotion(contact : Node2D):
	pass # #Spawns block next to the contact point

func AreaDeleterPotion(listOfTargets : Array):
	for body in listOfTargets:
		var dir : Vector2 = (body.global_position - explosionPosition).normalized()
		if body != player:
			body.get_parent().Remove()
	pass # Removes The Blocks

func GrowthEffectPotion(listOfTargets : Array):
	for body in listOfTargets:
		var dir : Vector2 = (body.global_position - explosionPosition).normalized()
		print(body)
		if body != player:
			body.get_parent().SetScale(0.5)
	pass #all blocks Grow

func EarthquakeEffectPotion(listOfTargets : Array):
	pass #all blocks shake

func MagnatismEffectPotion(listOfTargets : Array):
	pass # all blocks come together (find center point)

func JumpBoostPotion(player : Node2D, listOfTargets : Array):
	pass #typical

func SpeedUpPotion(player : Node2D, listOfTargets : Array):
	pass #typical

func DashPotionEffect(player : Node2D, listOfTargets : Array):
	pass # Adds force in the direction of the potion

func MorphPotion(player : Node2D, listOfTargets : Array):
	pass # typical celeste flower moment

func SlipperyPotion(player : Node2D, listOfTargets : Array):
	pass

func JumpResetPotion(player : Node2D, listOfTargets : Array):
	pass
