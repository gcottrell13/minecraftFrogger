class_name ControllableManager;

static var group_name = "controllable";
static var prop_name = "control_layer";

static func get_controllables(tree: SceneTree, layer: int) -> Array[Node]:
	if layer == -1:
		return tree.get_nodes_in_group(group_name);
	var nodes: Array[Node] = [];
	for node in tree.get_nodes_in_group(group_name):
		var node_layer = node.get(prop_name);
		if node_layer == null:
			node_layer = 0;
		if node_layer == layer:
			nodes.append(node);
	return nodes;

static func set_controllable(node: Node, layer: int):
	node.add_to_group(group_name);
	node.set(prop_name, layer);

static func unset_controllable(node: Node):
	node.remove_from_group(group_name);
