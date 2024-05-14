class_name Frog1
extends BaseCharacter

var cannot_move = false;

@onready var lookahead : ShapeCast3D = $Node3D/lookahead;
@onready var hitbox : ShapeCast3D = $Node3D/hitbox;

var distance_fallen : float = 0;


var radius : float = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = hitbox.shape.size.abs();
	radius = (shape.x + shape.z) / 4;
	meshCollection = $display;
	super();

func move_character(dir: Vector3):
	if not cannot_move and animate_curve == null:
		match base_move_character(dir, lookahead):
			MOVE_RESULT.CanMoveSafe:
				frog_jump(dir);
			MOVE_RESULT.CanMoveUnsafe:
				frog_jump(dir);

func frog_jump(dir: Vector3):
	var curve = Curve3D.new();
	var next = next_position - position;
	curve.add_point(Vector3.ZERO);
	curve.add_point(next / 2 + Vector3.UP / 2);
	curve.add_point(next);
	var timelen = 0.2 * dir.length_squared();
	animate_to_position(timelen, curve);

func do_special():
	move_character(facing_dir * 2);

func die(src):
	cannot_move = true;
	is_dead = true;
	super(src);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);
	if not is_dead:
		if animate_curve == null:
			if check_hitbox(hitbox, true, radius):
				position = next_position;
				fix_rotation();
			elif distance_fallen < 1:
				position.y -= 0.5;
				distance_fallen += 0.5;
			else:
				die(DAMAGE_SOURCE.Fall);
		else:
			position = next_position;
	elif animate_curve != null:
		position = next_position;
	if not is_dead:
		check_collision(hitbox);
