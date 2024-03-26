class_name SolidBlock
extends BaseBlock


@export var StandPoint : Vector3 = Vector3.UP * 0.5;


# Called when the node enters the scene tree for the first time.
func _ready():
	super();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _get_configuration_warnings():
	var warnings = [];
	if StandPoint == null:
		warnings.append("StandPoint is null");
	return warnings;
