class_name FrogCharacter
extends BaseCharacter

var cannot_move = false;

@export var camera_position: Vector3 = Vector3.UP + Vector3.BACK;
@onready var lookahead : ShapeCast3D = $Node3D/lookahead;
@onready var hitbox : ShapeCast3D = $Node3D/hitbox;


# Called when the node enters the scene tree for the first time.
func _ready():
	super();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);
	if not hitbox.is_colliding():
		# TODO: this means death
		return;
	
	var closest_ground: BlockNormal;
	var closest_ground_dist = 100;
	
	var closest_pusher: BlockNormal;
	var closest_pusher_dist = 100;
	
	for i in range(hitbox.get_collision_count()):
		var collision = hitbox.get_collider(i);
		if collision is BlockNormal:
			var dir: Vector3 = collision.get_direction();
			var angle = dir.angle_to(global_up);
			if angle > angle_tolerance:
				var d = (collision.global_position - global_position).length_squared();
				if d < closest_ground_dist:
					closest_ground = collision;
					closest_ground_dist = d;
			elif angle > PI - angle_tolerance:
				# TODO: get crushed?
				pass
			else:
				var d = (collision.global_position - global_position).length_squared();
				if d < closest_pusher_dist:
					closest_pusher = collision;
					closest_pusher_dist = d;
	
	if closest_pusher != null:
		var offset = get_parent().to_local(closest_pusher.global_position);
		position += offset;
	elif closest_ground != null:
		home_ray = closest_ground;
		home_block = closest_ground.get_parent();
		position = home_ray.global_position;
		
func move_character(dir: Vector3):
	pass
