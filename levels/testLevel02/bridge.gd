extends Node3D

var active : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_button_2_on_trigger(area):
	$Path3D.active = true;



func _on_button_2_on_untrigger(area):
	$Path3D.active = false;
