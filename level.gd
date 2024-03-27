@tool
class_name Level
extends Node


var manager : BlockManager;


# Called when the node enters the scene tree for the first time.
func _ready():
	manager = BlockManager.new();
	for child in get_children():
		if child is BaseBlock:
			manager.register_block(child.nearest_gridline(), child);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_neighbors(vec: Vector3i) -> NeighborData:
	for child in get_children():
		manager.register_block(Vector3i(child.position), child);
	return manager.get_neighbors(vec);
