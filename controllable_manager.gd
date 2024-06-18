class_name ControllableManager;

static var group_name = "controllable";
static var prop_name = "control_layer";

static func get_controllables(tree: SceneTree, layer: int) -> Array[BaseCharacter]:
	var nodes: Array[BaseCharacter] = [];
	for node in tree.get_nodes_in_group(group_name):
		var node_layer = node.get(prop_name);
		if node_layer == null:
			node_layer = 0;
		if node_layer == layer or layer == -1:
			nodes.append(node);
	return nodes;

static func set_controllable(node: BaseCharacter, layer: int):
	node.add_to_group(group_name);
	node.set(prop_name, layer);

static func unset_controllable(node: BaseCharacter):
	node.remove_from_group(group_name);
