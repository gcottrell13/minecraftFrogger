class_name BaseBlock
extends Node3D

var blockdata: BlockData;

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		var parent : Level = get_parent();
		parent.manager.register_block(nearest_gridline(), self);

func _exit_tree():
	if Engine.is_editor_hint():
		var parent : Level = get_parent();
		parent.manager.unregister_block(self);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		if Engine.is_editor_hint():
			var parent : Level = get_parent();
			parent.manager.register_block(nearest_gridline(), self);
			do_face_hiding();


func nearest_gridline():
	return Vector3i(position.snapped(Vector3.ONE));

func do_face_hiding():
	var parent : Level = get_parent();
	var neighbors = parent.manager.get_neighbors(nearest_gridline());
	print(neighbors);
