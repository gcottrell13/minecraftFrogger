class_name BaseCharacter
extends Node3D

var angle_tolerance = 0.4;

var global_up = Vector3.UP;
var home_ray: BlockNormal;
var home_block: SolidBlock;

var target_position: BlockNormal;
var target_block: SolidBlock;

var meshCollection : Node3D;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func clear_target():
	target_position = null;
	target_block = null;

func check_hitbox(hitbox: ShapeCast3D, die_if_fall = true, radius=1):
	var closest_ground: BlockNormal;
	var closest_ground_dist = 100;
	
	for i in range(hitbox.get_collision_count()):
		var collision = hitbox.get_collider(i);
		if collision is BlockNormal:
			var dir: Vector3 = collision.get_direction();
			var angle = dir.angle_to(global_up);
			if angle < angle_tolerance:
				var d = (collision.global_position - hitbox.global_position).length_squared();
				if d < closest_ground_dist:
					closest_ground = collision;
					closest_ground_dist = d;
	
	if closest_ground != null:
		home_ray = closest_ground;
		home_block = closest_ground.get_parent();
		position = get_parent().to_local(home_ray.global_position);
		global_up = home_ray.get_direction();
		look_at(get_closest_dir(home_ray), global_up);
	else:
		# TODO: fall down, and if ground cannot be found within the max fall distance, die.
		return;

func check_collision(hitbox: ShapeCast3D):
	var plane = Plane(global_up);
	
	while true:
		hitbox.force_shapecast_update();
		var pushed_vector: Vector3 = Vector3.ZERO;
		for i in range(hitbox.get_collision_count()):
			var collision = hitbox.get_collider(i);
			if collision is BlockNormal:
				pass
			elif collision is Area3D:
				pushed_vector += plane.project((global_position - collision.global_position)).normalized() / 10;
		if pushed_vector.is_zero_approx():
			break
		position += get_parent().to_local(pushed_vector);
		
func base_move_character(dir: Vector3, lookahead: ShapeCast3D):
	if meshCollection != null:
		meshCollection.rotate_y(Vector3.FORWARD.signed_angle_to(dir, Vector3.UP) - meshCollection.rotation.y);
	lookahead.position = dir;
	
	var max_y = 0.5;
	while lookahead.position.y < max_y:
		lookahead.force_shapecast_update();
		var moved_up = false;
		for i in range(lookahead.get_collision_count()):
			var collision = lookahead.get_collider(i);
			if collision is BlockNormal:
				pass
			elif collision is Area3D:
				if lookahead.position.y < max_y:
					lookahead.position.y += 0.1;
					moved_up = true;
					break;
				else:
					return;
		if not moved_up:
			break;
	
	if lookahead.position.y <= 0:
		lookahead.position.y = -0.1;
		lookahead.force_shapecast_update();
	
	check_hitbox(lookahead, true, 1);
	#lookahead.position = Vector3.ZERO;

func get_closest_dir(ray: BlockNormal) -> Vector3:
	var forward = to_global(Vector3.FORWARD);
	# Vector3.FORWARD * -global_basis.get_rotation_quaternion()
	# var forward = ray.to_local(to_global(Vector3.FORWARD));
	var closest = forward;
	var closest_dist = 10;
	for dir in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		var v = ray.to_global(dir) - forward;
		var d = v.length_squared();
		if d < closest_dist:
			closest = ray.to_global(dir);
			closest_dist = d;
	return closest;
