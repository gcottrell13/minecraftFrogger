extends FullSolidBlock


# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_x(randi_range(-1, 2) * PI/2);
	rotate_z(randi_range(-1, 2) * PI/2);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
