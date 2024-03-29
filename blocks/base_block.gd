@tool
class_name BaseBlock
extends Node3D

enum TransparencyMask {
	Solid,
	Glass,
	Water,
}

var old_neighbors: Array[BaseBlock] = [];

var face_hiding_decisions_made = {};
var last_updater: float;

@export var transparency_mask : TransparencyMask = TransparencyMask.Solid:
	set = set_mask;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		if Engine.is_editor_hint():
			var parent : Level = get_parent();
			parent.manager.register_block(nearest_gridline(), self);
			do_face_hiding();
			update_gizmos();


func nearest_gridline():
	return Vector3i(position.snapped(Vector3.ONE));

func set_mask(value):
	if value != transparency_mask:
		transparency_mask = value;
		do_face_hiding();

func do_face_hiding(RECURSE = 1, updater: float = 0):
	if updater == 0:
		updater = Time.get_unix_time_from_system();
	
	if last_updater != updater:
		last_updater = updater;
		face_hiding_decisions_made = {};
		
	var parent : Level = get_parent();
	for neighbor in old_neighbors:
		if RECURSE > 0:
			neighbor.do_face_hiding(RECURSE - 1, updater);
			
	var neighbors : Array[BaseBlock] = parent.get_neighbors(nearest_gridline());
	for face in get_children():
		if face in face_hiding_decisions_made:
			continue;
			
		if neighbors.size() == 0:
			_unhide_face(face);
		for neighbor in neighbors:
			if face is MeshInstance3D:
				if _should_hide_face(face, neighbor):
					_hide_face(face);
				else:
					_unhide_face(face);
				if RECURSE > 0:
					neighbor.do_face_hiding(RECURSE - 1, updater);
	old_neighbors = neighbors;

func _should_hide_face(face: MeshInstance3D, neighbor: BaseBlock) -> bool:
	for nface in neighbor.get_children():
		if nface is MeshInstance3D:
			if neighbor.transparency_mask == transparency_mask and \
				nface.global_position.is_equal_approx(face.global_position) and \
				nface.scale.is_equal_approx(face.scale):
				return true;
	return false;

func _hide_face(face: MeshInstance3D):
	if face.visible:
		face.visible = false;
		face_hiding_decisions_made[face] = false;
		print('hide face ', name, ' ', face.name);

func _unhide_face(face: MeshInstance3D):
	if not face.visible:
		face.visible = true;
		face_hiding_decisions_made[face] = true;
