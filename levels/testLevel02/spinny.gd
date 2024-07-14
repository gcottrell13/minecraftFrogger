extends Node3D

var active : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		rotate_z(delta * 0.4);


func _on_button_2_on_trigger(area):
	active = true;



func _on_button_2_on_untrigger(area):
	active = false;
