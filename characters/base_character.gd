class_name BaseCharacter
extends Node3D


var global_up = Vector3.UP;
var home_ray: RayCast3D;
var home_block: SolidBlock;

var target_position: RayCast3D;
var target_block: SolidBlock;

var hitbox : Area3D;
var lookahead : Area3D;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func clear_target():
	target_position = null;
	target_block = null;


func on_collide_with_raycast(block: SolidBlock, ray: RayCast3D, area: Area3D):
	# area should be a child of this node
	if area == hitbox and block != home_block:
		global_up = ray.target_position * ray.quaternion;
		home_block = block;
		home_ray = ray;
	elif area == lookahead and block != target_block:
		target_position = ray;
		target_block = block;

func move_character(event: Vector3):
	print(event);
