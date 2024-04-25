@tool
extends Level

@onready var frogScene = preload("res://characters/frog1/frog.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	super();
	if Engine.is_editor_hint():
		return;
	spawn_characters();

func spawn_characters():
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
				fade_to(dup, on_fadefromblack_end, 1);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);
	if not Engine.is_editor_hint():
		pass

func _on_no_controllables_left():
	fade_to(get_viewport().get_camera_3d(), on_fadetoblack_end, 0);


func on_fadetoblack_end(anim: FadeToBlackAnimation):
	remove_child(anim);
	fade_to(get_viewport().get_camera_3d(), on_fadefromblack_end, 1);
	

func on_fadefromblack_end(anim: FadeToBlackAnimation):
	remove_child(anim);
	spawn_characters();
