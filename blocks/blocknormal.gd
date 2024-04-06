class_name BlockNormal
extends Area3D

@onready var raycast : RayCast3D = $RayCast3D;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_direction() -> Vector3:
	return to_global(raycast.target_position) - global_position;
