class_name FrogCharacter
extends BaseCharacter

var cannot_move = false;

@export var camera_position: Vector3 = Vector3.UP + Vector3.BACK;



# Called when the node enters the scene tree for the first time.
func _ready():
	super();
	hitbox = $hitbox;
	lookahead = $lookaheadcollision;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);


func _on_hitbox_area_entered(area: Area3D):
	var diff = area.global_position - global_position;


func _on_hitbox_area_exited(area):
	pass # Replace with function body.


func _on_lookaheadcollision_area_entered(area):
	cannot_move = true;


func _on_lookaheadcollision_area_exited(area):
	cannot_move = false;
