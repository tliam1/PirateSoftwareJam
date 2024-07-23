extends Node2D

var gm : Node2D = null
@onready var gem_sprite = $gemSprite
@onready var area_2d = $gemSprite/Area2D
var collected : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	gm = get_tree().get_root().find_child("GameManager", true, false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (collected):
		area_2d.monitoring = false
		var tween : Tween = create_tween()
		var target : Vector2 = gm.GetFinalBlock().global_position
		collected = false
		tween.tween_property(self, "global_position", target, 1).from(global_position).set_trans(Tween.TRANS_EXPO)
		pass
	elif(!collected and area_2d.monitoring):
		pass
	pass


func _on_area_2d_body_entered(body):
	if(collected):
		return
	collected = true
	pass # Replace with function body.
