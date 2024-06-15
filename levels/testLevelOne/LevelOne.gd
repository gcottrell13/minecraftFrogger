@tool
extends Level

@onready var frogScene = preload("res://characters/frog1/frog.tscn");
var started_fadeout = false;
var respawning = false;

var spawnpoints: Array[SpawnPoint] = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	super();
	if not Engine.is_editor_hint() and OS.is_debug_build():
		spawnpoints = [
			$SpawnPoint,
			$SpawnPoint2,
			$SpawnPoint3,
			$SpawnPoint4,
		];
		setup_checkpoint_select(_checkpoint_select, spawnpoints);
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);

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


func _on_long_jump_tut_trigger_area_entered(area):
	if area.get_parent() is Frog1:
		var tut: Control = $LongJumpTutorial;
		tut.visible = true;
	
func _on_long_jump_tut_trigger_area_exited(area):
	if area.get_parent() is Frog1:
		var tut: Control = $LongJumpTutorial;
		tut.visible = false;
