@tool
class_name BaseBlock
extends Node3D

enum TransparencyMask {
	Solid,
	Glass,
	Water,
}

var old_neighbors: NeighborData = null;

@export var transparency_mask : TransparencyMask = TransparencyMask.Solid:
	set = set_mask;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _enter_tree():
	if Engine.is_editor_hint():
		var parent : Level = get_parent();
		parent.manager.register_block(nearest_gridline(), self);

func _exit_tree():
	if Engine.is_editor_hint():
		var parent : Level = get_parent();
		parent.manager.unregister_block(self);


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		if Engine.is_editor_hint():
			var parent : Level = get_parent();
			parent.manager.register_block(nearest_gridline(), self);
			do_face_hiding();


func nearest_gridline():
	return Vector3i(position.snapped(Vector3.ONE));

func set_mask(value):
	if value != transparency_mask:
		transparency_mask = value;
		do_face_hiding();

func do_face_hiding(RECURSE = 1):
	var parent : Level = get_parent();
	if old_neighbors != null:
		for key in old_neighbors.set_directions.keys():
			var n : BaseBlock = old_neighbors.get_neighbor(key);
			if RECURSE > 0:
				n.do_face_hiding(RECURSE - 1);
			
	var neighbors : NeighborData = parent.get_neighbors(nearest_gridline());
	for key in _face_names():
		if neighbors.has_neighbor(key):
			var n : BaseBlock = neighbors.get_neighbor(key);
			if _should_hide_face(key, n):
				_hide_face(key);
			else:
				_unhide_face(key);
			if RECURSE > 0:
				n.do_face_hiding(RECURSE - 1);
		else:
			_unhide_face(key);
	old_neighbors = neighbors;

func _should_hide_face(dir: String, neighbor: BaseBlock) -> bool:
	return false

func _hide_face(dir: String):
	pass

func _unhide_face(dir: String):
	pass

func _child_by_name(dir: String) -> MeshInstance3D:
	return null;

func _face_names() -> Array[String]:
	return ['up', 'down', 'south', 'north', 'east', 'west'];

func opposite_face(dir: String) -> String:
	match dir:
		'up': return 'down';
		'down': return 'up';
		'south': return 'north';
		'east': return 'west';
		'west': return 'east';
		'north': return 'south';
	return '';
