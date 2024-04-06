class_name BaseCharacter
extends Node3D

var angle_tolerance = 0.3;

var global_up = Vector3.UP;
var home_ray: BlockNormal;
var home_block: SolidBlock;

var target_position: BlockNormal;
var target_block: SolidBlock;

var radius : float = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func clear_target():
	target_position = null;
	target_block = null;

func check_hitbox(hitbox: ShapeCast3D):
	if not hitbox.is_colliding():
		# TODO: fall down, and if ground cannot be found within the max fall distance, die.
		return;
	
	var closest_ground: BlockNormal;
	var closest_ground_dist = 100;
	
	var pushed_vector: Vector3 = Vector3.ZERO;
	
	for i in range(hitbox.get_collision_count()):
		var collision = hitbox.get_collider(i);
		if collision is BlockNormal:
			var dir: Vector3 = collision.get_direction();
			var angle = dir.angle_to(global_up);
			if angle < angle_tolerance:
				var d = (collision.global_position - global_position).length_squared();
				if d < closest_ground_dist:
					closest_ground = collision;
					closest_ground_dist = d;
		elif collision is Area3D:
			var point = to_local(hitbox.get_collision_point(i));
			pushed_vector += point.normalized() * (radius - point.length());
	
	#if closest_pusher != null:
		#var offset = get_parent().to_local(closest_pusher.get_direction() + position) / 5;
		#position += offset;
	if closest_ground != null:
		home_ray = closest_ground;
		home_block = closest_ground.get_parent();
		rotate_y(get_closest_dir(home_ray));
		position = get_parent().to_local(home_ray.global_position);
	position += pushed_vector;
		
func move_character(dir: Vector3):
	pass

func get_closest_dir(ray: BlockNormal) -> float:
	var forward = to_global(Vector3.FORWARD);
	# var forward = ray.to_local(to_global(Vector3.FORWARD));
	var closest = forward;
	var closest_dist = 10;
	for dir in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		var v = ray.to_global(dir) - forward;
		var d = v.length_squared();
		if d < closest_dist:
			closest = ray.to_global(dir);
			closest_dist = d;
	return Vector3.FORWARD.signed_angle_to(to_local(closest), Vector3.UP);
