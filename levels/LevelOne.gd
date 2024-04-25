@tool
extends Level

@onready var frogScene = preload("res://characters/frog1/frog.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	super();
	if Engine.is_editor_hint():
		return;
	for child in find_children("", "SpawnPoint"):
		var spawn_children: Array[Node] = child.get_children();
		var frog: Node3D = frogScene.instantiate();
		add_child(frog);
		frog.position = child.position;
		frog.rotation = child.rotation;
		ControllableManager.set_controllable(frog, 0);
		for spawnchild in spawn_children:
			if spawnchild.owner != self:
				continue;
			var dup = spawnchild.duplicate();
			frog.add_child(dup);
			if spawnchild is Camera3D:
				CameraManager.add_camera_target(dup, 0);
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);
	if not Engine.is_editor_hint():
		pass
