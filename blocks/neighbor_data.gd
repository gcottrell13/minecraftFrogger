class_name NeighborData

var up : BaseBlock;
var down : BaseBlock;
var north : BaseBlock;
var south : BaseBlock;
var east : BaseBlock;
var west : BaseBlock;

var set_directions: Dictionary = {};

func set_neighbor(dir: String, neighbor: BaseBlock):
	set(dir, neighbor);
	set_directions[dir] = neighbor;

func get_neighbor(dir: String) -> BaseBlock:
	return set_directions[dir];

func has_neighbor(dir: String):
	return set_directions.has(dir);

func _to_string():
	var f = []
	for k in set_directions.keys():
		if get(k) != null:
			f.append(k + '=' + get(k).name);
	if f.size() == 0:
		return "[no neighbors]";
	return '[' + (','.join(f)) + ']';
