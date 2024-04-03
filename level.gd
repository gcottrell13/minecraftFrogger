@tool
class_name Level
extends Node


var manager : BlockManager;


# Called when the node enters the scene tree for the first time.
func _ready():
	manager = BlockManager.new();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func register_children():
	for child in get_children():
		manager.register_block(Vector3i(child.position), child);

func get_neighbors(vec: Vector3i) -> Array[BaseBlock]:
	return manager.get_neighbors(vec);
