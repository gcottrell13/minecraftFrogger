class_name Frog1
extends BaseCharacter

var cannot_move = false;

@onready var lookahead : ShapeCast3D = $Node3D/lookahead;
@onready var hitbox : ShapeCast3D = $Node3D/hitbox;
@onready var curveJumpOne = $CurveJumpOne;


var radius : float = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = hitbox.shape.size.abs();
	radius = (shape.x + shape.z) / 4;
	meshCollection = $display;
	super();

func move_character(dir: Vector3):
	if not cannot_move and animate_curve == null:
		if base_move_character(dir, lookahead):
			var angle = Vector3.FORWARD.signed_angle_to(dir, Vector3.UP);
			var curve = Curve3D.new();
			curve.add_point(Vector3.ZERO);
			curve.add_point((next_position - position) / 2 + Vector3.UP / 2);
			curve.add_point(next_position - position);
			animate_to_position(0.2 * dir.length_squared(), curve);

func do_special():
	move_character(facing_dir * 2);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);
	if animate_curve == null:
		if check_hitbox(hitbox, true, radius):
			fix_rotation();
		else:
			cannot_move = true;
	position = next_position;
	check_collision(hitbox);
