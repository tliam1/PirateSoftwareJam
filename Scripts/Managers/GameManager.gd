extends Node2D

@export var potionList : Array[String]
var currentPotion : int = 0

var player : Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	print(player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func GetCurrentPotionEffect() -> String:
	if currentPotion >= potionList.size():
		return "null"
	return potionList[currentPotion]

func NextPotion() -> void:
	currentPotion += 1
