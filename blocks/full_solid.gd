@tool
class_name FullSolidBlock
extends SolidBlock

func _child_by_name(str: String) -> MeshInstance3D:
	match str:
		"up": return $up;
		"down": return $down;
		"west": return $west;
		"east": return $east;
		"north": return $north;
		"south": return $south;
	return null;

func _should_hide_face(dir: String, neighbor: BaseBlock) -> bool:
	if neighbor.position != position + Vector3(BlockManager.deltas[dir]):
		return false;
	if neighbor.transparency_mask == transparency_mask:
		return true;
	return false;

func _hide_face(dir: String):
	print('hide ', dir);
	_child_by_name(dir).visible = false;
	
func _unhide_face(dir: String):
	print('unhide ', dir);
	_child_by_name(dir).visible = true;
