class_name BaseCharacter
extends BaseEntity

var is_dead : bool = false;

var target_position: BlockNormal;
var target_block: SolidBlock;

var meshCollection : Node3D;

var facing_dir : Vector3;

var animate_time_length: float = 0;
var animate_current_time: float = 0;
var animate_curve: Curve3D;
var animate_prev_sample: Vector3 = Vector3.ZERO;

enum DAMAGE_SOURCE {
	Fall,
	Water,
	Cleaved,
	Normal,
}

enum MOVE_RESULT {
	CanMoveSafe,
	CanMoveUnsafe,
	CannotMove,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animate_curve != null:
		animate_current_time += delta;
		var curve_length = animate_curve.get_baked_length();
		var dist = curve_length * min(1, animate_current_time / animate_time_length);
		var sample = animate_curve.sample_baked(dist);
		var sample_delta = sample - animate_prev_sample;
		next_position = position + sample_delta;
		animate_prev_sample = sample;
		if animate_current_time >= animate_time_length:
			animate_curve = null;
		


func clear_target():
	target_position = null;
	target_block = null;


func move_character(dir: Vector3):
	pass


func base_move_character(dir: Vector3, lookahead: ShapeCast3D) -> MOVE_RESULT:
	if meshCollection != null:
		meshCollection.rotate_y(Vector3.FORWARD.signed_angle_to(dir, Vector3.UP) - meshCollection.rotation.y);
	facing_dir = dir.normalized();
	lookahead.position = dir;
	
	var max_y = 0.5;
	while lookahead.position.y <= max_y:
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
					return MOVE_RESULT.CannotMove;
		if not moved_up:
			break;
	
	if lookahead.position.y > max_y:
		return MOVE_RESULT.CannotMove;
	
	if lookahead.position.y <= 0:
		lookahead.position.y = -0.3 * dir.length();
		lookahead.force_shapecast_update();
	
	if check_hitbox(lookahead, true, 1):
		#lookahead.position = Vector3.ZERO;
		return MOVE_RESULT.CanMoveSafe;
	
	#lookahead.position = Vector3.ZERO;
	return MOVE_RESULT.CanMoveUnsafe;

func animate_to_position(time_length: float, curve: Curve3D):
	animate_curve = curve;
	animate_time_length = time_length;
	animate_current_time = 0;
	animate_prev_sample = animate_curve.sample_baked(0);

func do_special():
	pass

func die(damage_source: DAMAGE_SOURCE):
	ControllableManager.unset_controllable(self);
	var parent = get_parent();
	await get_tree().create_timer(1.0).timeout
	parent.remove_child(self);
