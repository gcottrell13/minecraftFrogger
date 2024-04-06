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
		return;
	for i in range(hitbox.get_collision_count()):
		var collision = hitbox.get_collider(i);
		if collision is Area3D:
			pass

