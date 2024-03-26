class_name BlockManager


var data = {};


static var deltas = {
	"up": Vector3i.UP,
	"down": Vector3i.DOWN,
	"left": Vector3i.LEFT,
	"right": Vector3i.RIGHT,
	"forward": Vector3i.FORWARD,
	"back": Vector3i.BACK,
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
	var octant = diagonals.find(pos.sign());
	assert (octant != -1);
	var id = abs(pos.x) + abs(pos.y) << 8 + abs(pos.z) << 16 + octant << 24;
	return id;

func get_block(pos: Vector3i) -> BlockData:
	var id = _pos_to_id(pos);
	if data.has(id):
		return data[id]
	return null;


func get_neighbors(pos: Vector3i) -> Array[BlockData]:
	var neighbors = [];
	for delta in deltas.values():
		var npos : Vector3i = pos + delta;
		var id = _pos_to_id(npos);
		if data.has(id):
			neighbors.append(data[id])
	return neighbors
