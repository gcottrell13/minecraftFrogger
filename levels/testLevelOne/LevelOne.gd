@tool
extends Level

@onready var frogScene = preload("res://characters/frog1/frog.tscn");
var started_fadeout = false;
var respawning = false;

@onready var movePlatform1 : PathFollow3D = $MOVEPLATFORM1/PathFollow3D;
@onready var enemy1 : PathFollow3D = $ENEMY1/PathFollow3D;

var spawnpoints: Array[SpawnPoint] = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	super();
	if not Engine.is_editor_hint() and OS.is_debug_build():
		spawnpoints = [
			$SpawnPoint,
			$SpawnPoint2,
			$SpawnPoint3,
		];
		setup_checkpoint_select(_checkpoint_select, spawnpoints);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);
	if not Engine.is_editor_hint():
		movePlatform1.progress += delta * 2;
		enemy1.progress += delta * 2;

func _on_no_controllables_left():
	if not started_fadeout:
		started_fadeout = true;
		respawning = true;
		fade_to(get_viewport().get_camera_3d(), on_fadetoblack_end, 0);

func _checkpoint_select(index: int):
	var spawn = spawnpoints[index];
	last_checkpoint_index = spawn.index;
	for child in get_children():
		if child is Frog1:
			remove_child(child);

func on_fadetoblack_end(anim: FadeToBlackAnimation):
	super(anim);
	if respawning:
		spawn_characters(last_checkpoint_index, frogScene);
	
	
func on_fadefromblack_end(anim: FadeToBlackAnimation):
	remove_child(anim);
	if respawning:
		started_fadeout = false;
		respawning = false;
