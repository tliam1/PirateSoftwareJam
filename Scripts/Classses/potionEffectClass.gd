class_name PotionEffects
extends Resource

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

func AttractBlocksToPlayerEffect(player : Node2D, listOfTargets : Array):
	pass # moves target to player

func ZeroGravityEffect(listOfTargets : Array): #
	pass # makes targets have zero gravity (adds some force to blocks)

func BlastEffect(listOfTargets : Array, blastPosition : Vector2):
	
	pass # causes a blast (blasts player and blocks)

func TeleportationEffect(player : Node2D, newPosition : Vector2):
	pass # teleports player to contact position 

func GravityShift(player : Node2D, gravity_scale : float, listOfTargets : Array):
	pass # Alters gravity by a modifier

func ReverseGravityPotion(player : RigidBody2D, gravity_scale : float, listOfTargets : Array):
	pass # flips gravity for a short amount of time

func StickyPotion(listOfTargets : Array):
	pass # makes the player stick to things
	
func SpawnBlockPotion(contact : Node2D):
	pass # #Spawns block next to the contact point

func AreaDeleterPotion(listOfTargets : Array):
	pass # Removes The Blocks

func GrowthEffectPotion(listOfTargets : Array):
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
