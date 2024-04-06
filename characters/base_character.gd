class_name BaseCharacter
extends Node3D

var angle_tolerance = 0.3;

var global_up = Vector3.UP;
var home_ray: BlockNormal;
var home_block: SolidBlock;

var target_position: BlockNormal;
var target_block: SolidBlock;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func clear_target():
	target_position = null;
	target_block = null;

func move_character(event: Vector3):
	# print(event);
	pass
