extends Node2D

@export var potionList : Array[String]
var currentPotion : int = 0
var playerShadow : Node2D
var canShadowWalk : bool = false
var player : Node2D
var levelCompleteBlock : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	playerShadow = get_node("playerShadow")
	playerShadow.modulate.a = 0.0
	print(player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!canShadowWalk):
		playerShadow.modulate.a = 0
	else:
		playerShadow.modulate.a = 1
	pass


func GetCurrentPotionEffect() -> String:
	if currentPotion >= potionList.size():
		return "null"
	return potionList[currentPotion]

func NextPotion() -> void:
	currentPotion += 1

func GetShadowState():
	return canShadowWalk

func SetShadowState(val : bool) -> void:
	canShadowWalk = val

func GetShadowPosition() -> Vector2:
	return playerShadow.global_position

func SetPlayerShadow():
	canShadowWalk = true
	playerShadow.global_position = player.position
	playerShadow.modulate.a = 1.0
 
func AssignFinalBlock(block : Node2D):
	levelCompleteBlock = block

func GetFinalBlock() -> Node2D:
	return levelCompleteBlock

func ShadowWalk():
	pass
