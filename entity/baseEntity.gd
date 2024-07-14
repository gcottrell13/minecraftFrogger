class_name BaseEntity
extends Node3D

var angle_tolerance = 0.4;

var global_up = Vector3.UP;
var home_ray: BlockNormal;
var home_block: SolidBlock;

var next_position: Vector3;

func _ready():
	global_up = global_transform.basis * Vector3.UP;

func get_collision_with_hitbox(hitbox: ShapeCast3D, radius = 1) -> BlockNormal:
	var closest_ground: BlockNormal;
	var closest_ground_dist = 100;
	
	for i in range(hitbox.get_collision_count()):
		var collision = hitbox.get_collider(i);
		if collision is BlockNormal:
			var dir: Vector3 = collision.get_direction();
			var angle = dir.angle_to(global_up);
			if angle < angle_tolerance:
				var d = (collision.global_position - hitbox.global_position).length_squared();
				if d < closest_ground_dist and d < radius:
					closest_ground = collision;
					closest_ground_dist = d;
	return closest_ground;

func check_hitbox(hitbox: ShapeCast3D, radius=1) -> bool:
	var closest_ground = get_collision_with_hitbox(hitbox, radius);
	if closest_ground != null:
		home_ray = closest_ground;
		home_block = closest_ground.get_parent();
		next_position = get_parent().to_local(home_ray.global_position);
		return true;
	else:
		# TODO: fall down, and if ground cannot be found within the max fall distance, die.
		home_ray = null;
		home_block = null;
		next_position = position + Vector3(hitbox.position.x, 0, hitbox.position.z);
		return false;

func check_collision(hitbox: ShapeCast3D):
	var plane = Plane(global_up);
	var count = 0;
	
	while count < 10:
		count += 1;
		
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

func fix_rotation():
	global_up = home_ray.get_direction();
	look_at(get_closest_dir(home_ray), global_up);

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

func get_level() -> Level:
	var parent = get_parent();
	var root = get_tree().root;
	while not (parent is Level):
		parent = parent.get_parent();
		if parent == root:
			return null;
	return parent;
