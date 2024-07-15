@tool
extends "res://blocks/graybrick/GrayBrick.gd"

var dir = 1;
@export var speed = 0.5;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var z0 = 0;
	var z1 = -1;
	
	var y0 = 5.5;
	var y1 = 4.5;

	var r0 = 0;
	var r1 = 90;
	
	var p = abs(r1-r0) / abs(z1-z0);
	if dir == 1:
		position.z = move_toward(position.z, z1, delta * speed);
		position.y = move_toward(position.y, y1, delta * speed);
		rotation_degrees.x = move_toward(rotation_degrees.x, r1, delta * speed * p);
		if is_equal_approx(position.z, z1):
			dir = -1;
	elif dir == -1:
		position.z = move_toward(position.z, z0, delta * speed);
		position.y = move_toward(position.y, y0, delta * speed);
		rotation_degrees.x = move_toward(rotation_degrees.x, r0, delta * speed * p);
		if is_equal_approx(position.z, z0):
			dir = 1;
