@tool
class_name BlockManager


var data = {};
var blockToId = {};


static var deltas = {
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

func _pos_to_id(pos: Vector3i):
	var octant = -1;
	var octpos = Vector3i(pos);
	if octpos.x == 0:
		octpos.x = 1;
	if octpos.y == 0:
		octpos.y = 1;
	if octpos.z == 0:
		octpos.z = 1;
	var sign = octpos.sign();
	for i in range(diagonals.size()):
		if diagonals[i] == sign:
			octant = i;
			break;
	
	assert (octant != -1);
	var id = abs(pos.x) + abs(pos.y) << 8 + abs(pos.z) << 16 + octant << 24;
	return id;

func get_block(pos: Vector3i) -> BaseBlock:
	if data.has(pos):
		return data[pos]
	return null;

func unregister_block(block: BaseBlock):
	if block in blockToId:
		data.erase(blockToId[block]);
		blockToId.erase(block);

func register_block(pos: Vector3i, block: BaseBlock):
	if block in blockToId:
		if pos == blockToId[block]:
			return;
		var oldid = blockToId[block];
		data.erase(oldid);
		blockToId.erase(block);
	
	data[pos] = block;
	blockToId[block] = pos;


func get_neighbors(pos: Vector3i) -> Array[BaseBlock]:
	var neighbors : Array[BaseBlock] = [];
	for dir in deltas.keys():
		var delta = deltas[dir];
		var npos : Vector3i = pos + delta;
		if data.has(npos):
			neighbors.append(data[npos]);
	return neighbors
