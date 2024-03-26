@tool
extends EditorPlugin

const MyCustomGizmoPlugin = preload("res://addons/gizmo/gizmo.gd")

var gizmo_plugin = MyCustomGizmoPlugin.new()

func _enter_tree():
	add_custom_type("VoxelEditorNode", "Node3D", preload("res://addons/gizmo/VoxelEditorNode.gd"), preload("res://icon.svg"))
	gizmo_plugin.undo_redo = get_undo_redo()
	add_node_3d_gizmo_plugin(gizmo_plugin)


func _exit_tree():
	remove_node_3d_gizmo_plugin(gizmo_plugin)
