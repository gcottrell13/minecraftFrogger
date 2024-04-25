@tool
class_name BlockManager


var data = {}; # dictionary of [vector3i] => Array[BaseBlock]
var blockToId = {};

var blocksize = Vector3i.ONE * 3;

static var deltas = {
	"zero": Vector3i.ZERO,
	"up": Vector3i.UP,
	"down": Vector3i.DOWN,
	"west": Vector3i.LEFT,
	"east": Vector3i.RIGHT,
	"north": Vector3i.FORWARD,
	"south": Vector3i.BACK,
}

static var diagonals = [
	Vector3i(1, 1, 1),
	Vector3i(1, 1, -1),
	Vector3i(1, -1, 1),
	Vector3i(1, -1, -1),
	Vector3i(-1, 1, 1),
	Vector3i(-1, 1, -1),
	Vector3i(-1, -1, 1),
	Vector3i(-1, -1, -1),
]

func get_block(pos: Vector3i) -> BaseBlock:
	if data.has(pos):
		return data[pos]
	return null;

func unregister_block(block: BaseBlock):
	if block in blockToId:
		data.erase(blockToId[block]);
		blockToId.erase(block);

func register_block(pos: Vector3, block: BaseBlock):
	var pos3i = Vector3i(pos.snapped(blocksize));
	
	if block in blockToId:
		if pos3i == blockToId[block]:
			return;
		var oldid = blockToId[block];
		var list: Array[BaseBlock] = data[oldid];
		list.remove_at(list.find(block));
		if list.size() == 0:
			data.erase(oldid);
		blockToId.erase(block);
	
	if pos3i not in data:
		var a: Array[BaseBlock] = [];
		data[pos3i] = a;
	data[pos3i].append(block);
	blockToId[block] = pos3i;


func get_neighbors(pos: Vector3) -> Array[BaseBlock]:
	var pos3i = Vector3i(pos.snapped(blocksize));
	
	var neighbors : Array[BaseBlock] = [];
	for dir in deltas.keys():
		var delta = deltas[dir];
		var npos : Vector3i = pos3i + delta * blocksize;
		if npos in data:
			neighbors.append_array(data[npos]);
	return neighbors
