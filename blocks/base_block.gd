class_name BaseBlock
extends Node3D

enum TransparencyMask {
	Solid,
	Glass,
	Water,
}

@export var hidden_faces := {};

@export var old_neighbors: Array[BaseBlock] = [];

var face_hiding_decisions_made = [];
var last_updater: float;

var level: Level;

@export var transparency_mask : TransparencyMask = TransparencyMask.Solid;

var last_position : Vector3 = Vector3.ZERO;
var _intermediate_position : Vector3 = Vector3.ZERO;
var last_tick_time : float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_notify_local_transform(true);
	last_position = position;
	_intermediate_position = position;
	if hidden_faces == null:
		hidden_faces = {};
	for child in get_meshes():
		if child.name in hidden_faces:
			child.visible = false;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	last_position = _intermediate_position;
	_intermediate_position = global_position;
	last_tick_time = delta;

func _notification(what: int) -> void:
	if what == NOTIFICATION_LOCAL_TRANSFORM_CHANGED:
		do_face_hiding();

func nearest_gridline():
	return Vector3i(position.snapped(Vector3.ONE));

#func set_mask(value):
	#if value != transparency_mask:
		#transparency_mask = value;
		#do_face_hiding();

func get_projected_position_delta(future_time: float) -> Vector3:
	if last_tick_time <= 0:
		return Vector3.ZERO;
	return (global_position - last_position) * future_time / last_tick_time;

func do_face_hiding(RECURSE = 1, updater: float = 0):
	#print(name, ' hiding ', RECURSE);
	if !is_inside_tree():
		return;
	if level == null:
		print(name, " LEVEL NULL");
		return;
	
	if updater == 0:
		updater = Time.get_unix_time_from_system();
		level.register_children();
	
	if last_updater != updater:
		last_updater = updater;
		face_hiding_decisions_made = [];
		
	for neighbor in old_neighbors:
		if neighbor != null and neighbor != self and RECURSE > 0:
			neighbor.do_face_hiding(RECURSE - 1, updater);
	
	var neighbors : Array[BaseBlock] = level.get_neighbors(position);
	if neighbors.size() > 0:
		for face in get_meshes():
			if face.name in face_hiding_decisions_made:
				continue;
			_unhide_face(face, true);
			for neighbor in neighbors:
				if neighbor != self and face is MeshInstance3D and neighbor.is_inside_tree() and not neighbor.position.is_equal_approx(position):
					if _should_hide_face(face, neighbor):
						_hide_face(face, true);
		for neighbor in neighbors:
			if neighbor != self and RECURSE > 0 and neighbor.is_inside_tree():
				neighbor.do_face_hiding(RECURSE - 1, updater);
	else:
		for face in get_meshes():
			if face.name in face_hiding_decisions_made:
				continue;
			_unhide_face(face, true);
			
	old_neighbors = neighbors;
	update_gizmos();

func _should_hide_face(face: MeshInstance3D, neighbor: BaseBlock) -> bool:
	for nface in neighbor.get_meshes():
		if nface is MeshInstance3D:
			if neighbor.transparency_mask == transparency_mask and \
				nface.global_position.is_equal_approx(face.global_position) and \
				nface.scale.is_equal_approx(face.scale):
				return true;
	return false;

func _hide_face(face: MeshInstance3D, commit=false):
	if face.name not in hidden_faces:
		face.visible = false;
		hidden_faces[face.name] = true;
		if commit:
			face_hiding_decisions_made.append(face.name);

func _unhide_face(face: MeshInstance3D, commit=false):
	if face.name in hidden_faces:
		face.visible = true;
		hidden_faces.erase(face.name);
		if commit:
			face_hiding_decisions_made.append(face.name);

func get_meshes():
	var meshes: Array[MeshInstance3D] = []
	for child in get_children():
		if child is MeshInstance3D:
			meshes.append(child);
	return meshes;

func block_disable():
	visible = false;
	process_mode = Node.PROCESS_MODE_DISABLED;

func block_enable():
	visible = true;
	process_mode = Node.PROCESS_MODE_INHERIT;

func block_toggle():
	if visible:
		block_disable();
	else:
		block_enable();
