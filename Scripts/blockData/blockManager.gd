extends Node
var childrenList : Array = []
var snapShot : Array = []
var snapShotPlaced : bool = false
var newBlocks : Array = []
var gameManager : Node2D = null
# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager = get_tree().get_root().find_child("GameManager", true, false)
	childrenList = get_children()
	for child in childrenList:
		if(child.isFinalBlock):
			gameManager.AssignFinalBlock(child)
#	allBlocks = childrenList.duplicate()
	# print(childrenList)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func AddNewBlock(block : Node2D):
	newBlocks.append(block)
	if not snapShotPlaced:
		snapShot.append(SaveNodeState(block))

func DeleteBlock(block : Node2D):
	if !snapShotPlaced and snapShot.has(block):
		var index = snapShot.find(block)
		snapShot.remove_at(index)

func SaveSnapShot():
	snapShot = []
	for child in childrenList:
		snapShot.append(SaveNodeState(child))

func ReloadSnapShot():
	# delete blocks not in snapshot
	# move all blocks back to snapshot position
	pass

#func GetAllChildren(in_node,arr:=[]): 
# this actively gets the full array of children (and their nested children) recursively
#	arr.push_back(in_node)
#	for child in in_node.get_children():
#		arr = GetAllChildren(child,arr)
#	return arr

func SaveNodeState(node: Node2D) -> Dictionary:
	var state = {
		"instance_id": node.get_instance_id(),
		"scene_path": node.get_scene().resource_path,
		"position": node.position,
		"rotation": node.rotation,
		"scale": node.scale,
		"properties": {}  # Add any other properties you want to save
	}
	return state

func LoadNodeState(state: Dictionary) -> Node2D:
	var scene: PackedScene = load(state["scene_path"])
	var node: Node2D = scene.instance() as Node2D
	node.position = state["position"]
	node.rotation = state["rotation"]
	node.scale = state["scale"]
	# Restore other properties as needed
	return node

