
extends EditorNode3DGizmoPlugin


var icon = preload("res://icon.svg")

var undo_redo : EditorUndoRedoManager;

func _get_gizmo_name():
	return "VoxelGizmo"


func _has_gizmo(node):
	return node is SolidBlock


func _init():
	create_material("main", Color(1, 0, 0))
	create_handle_material("handles")
	create_handle_material("handles-selected", true, icon)

func _get_handle_name(gizmo, handle_id, secondary):
	return "Angle"

func _set_handle(gizmo, handle_id, secondary, camera: Camera3D, screen_pos):
	#var node3d : BaseBlock = gizmo.get_node_3d();
	#var co = camera.project_ray_origin(screen_pos);
	#var cr = camera.project_ray_normal(screen_pos);
	#var xslope = cr.x / cr.y;
	#var zslope = cr.z / cr.y;
	#var dy = node3d.position.y - co.y;
	#var t = Vector3(co.x + xslope * dy, node3d.position.y, co.z + zslope * dy) - node3d.position;
	#node3d.StandPoint = snapped(atan2(t.x, t.z), 3.14 / 2);
	#node3d.update_gizmos();
	pass


func _get_handle_value(gizmo, handle_id, secondary):
	var node3d : SolidBlock = gizmo.get_node_3d();
	return node3d.StandPoint;
	

func _commit_handle(gizmo, handle_id, secondary, restore, cancel):
	var node3d : SolidBlock = gizmo.get_node_3d();
	if cancel:
		node3d.StandPoint = restore;
		return
	
	undo_redo.create_action("change stand point");
	undo_redo.add_do_property(node3d, "StandPoint", node3d.StandPoint);
	undo_redo.add_undo_property(node3d, "StandPoint", restore);
	undo_redo.commit_action()


func _redraw(gizmo):
	gizmo.clear()

	var node3d : SolidBlock = gizmo.get_node_3d()
	if node3d.StandPoint == null:
		return;

	var lines = PackedVector3Array()
	
	lines.push_back(Vector3(0, 0, 0))
	lines.push_back(node3d.StandPoint)

	var handles = PackedVector3Array()

	handles.push_back(node3d.StandPoint)
	
	gizmo.add_lines(lines, get_material("main", gizmo), false)
	gizmo.add_handles(handles, get_material("handles", gizmo), [])
