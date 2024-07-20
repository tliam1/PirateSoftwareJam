extends Node2D

var player : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	print(player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
