extends Camera3D

var initial_position : Vector3;


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var level : Level = get_parent().get_parent();
	
	position = initial_position;
	
	var level_relative_pos = level.to_local(global_position);
	level_relative_pos.x = 0;
	
	if level_relative_pos.z < -2:
		level_relative_pos.z = -2;
	
	position = get_parent().to_local(level.to_global(level_relative_pos));
	
