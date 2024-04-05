class_name CameraManager;


static var camera_group_name = "camera";
static var camera_prop_name = "camera_priority";


static func add_camera_target(target: Node3D, prio: int):
	for child in target.get_children():
		if child is Camera3D:
			target.add_to_group(camera_group_name);
			target.set(camera_prop_name, prio);

static func remove_camera_target(target: Node3D):
	target.remove_from_group(camera_group_name);


static func get_camera_targets(tree: SceneTree) -> Array[Camera3D]:
	if not tree.has_group(camera_group_name):
		return [];
	var camera_members = tree.get_nodes_in_group(camera_group_name);
	var highest_prio = 0;
	var targets: Array[Camera3D] = [];
	for group_member in camera_members:
		var prio = group_member.get(camera_prop_name);
		if prio == null or prio < 0:
			prio = 0;
		if prio > highest_prio:
			targets = [group_member];
			highest_prio = prio;
		elif prio == highest_prio:
			for child in group_member.get_children():
				if child is Camera3D:
					targets.append(child);
	return targets;
