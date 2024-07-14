@tool
extends EditorScript

var radius = 21.0;
var platform_width = 10.0;
var block_scene = preload("res://blocks/graybrick/GrayBrick.tscn");

var flip = Vector3(1, 1, 1);


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var scene = get_scene();
	print(scene.name);
	
	# Chord Length = 2 × r × sin(c/2)
	# chord length = 1
	# solve for c
	var block_angle_delta = abs(asin(1/(2*radius))*2);
	
	print("block_angle_delta ", block_angle_delta);
	
	var is_even_platform = fmod(platform_width, 2) == 0;
	if is_even_platform:
		platform_width += 1;
		
	var half_platform_width = (platform_width - 1) / 2;
	
	var deltas = [
		[Vector3(1, 0, 0), Vector3(0, 1, 0)],
		[Vector3(0, 1, 0), Vector3(0, 0, 1)],
		[Vector3(0, 0, 1), Vector3(1, 0, 0)],
	];
	
	radius -= 0.5;
	
	for delta_pair in deltas:
		var one = delta_pair[0];
		var two = delta_pair[1];
		
		var i = half_platform_width;
		while i >= 0:
			var block = add_block();
			block.position = one * i + two * (radius + half_platform_width);
			block.position *= flip;
			i -= 1;
		
		i = half_platform_width;
		while i > 0:  # strictly GT, not GTE, so that there are no duplicates
			var block = add_block();
			block.position = two * i + one * (radius + half_platform_width);
			block.position *= flip;
			i -= 1;
		
		var cross: Vector3 = one.cross(two);
		var one_dir = one.max_axis_index();
		var two_dir = two.max_axis_index();
		var flip_angle = -1 if (flip[one_dir] == -1) != (flip[two_dir] == -1) else 1;
		
		var oneplustwo = one + two;
		var angle = block_angle_delta;
		var halfpi = PI / 2;
		var C = 0;
		while angle <= halfpi:
			C += 1;
			var block = add_block();
			block.rotate(cross, angle * flip_angle);
			block.position = cos(angle) * one * radius + sin(angle) * two * radius + oneplustwo * half_platform_width + (C % 2) * 0.001 * cross;
			block.position *= flip;
			angle += block_angle_delta;
			

func add_block() -> Node3D:
	var scene = get_scene();
	var block: Node3D = block_scene.instantiate();
	scene.add_child(block);
	block.owner = scene;
	return block;
	
