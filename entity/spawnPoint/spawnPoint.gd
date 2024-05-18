class_name SpawnPoint
extends BaseEntity

@export var hide : bool = false;
@export var index : int = 0;
@export var debug_title : String = "";

@export var copy_children_from : SpawnPoint;

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = not hide;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_area_entered(area):
	if area.name != "CharacterHitbox":
		return;
	
	var level = get_level();
	if level.last_checkpoint_index >= index:
		return;
	level.last_checkpoint_index = index;
	$GPUParticles3D.emitting = true;
	
