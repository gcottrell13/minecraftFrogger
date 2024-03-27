class_name SolidBlock
extends BaseBlock


@export var StandPoint : Vector3 = Vector3.UP * 0.5;

func _get_configuration_warnings():
	var warnings = [];
	if StandPoint == null:
		warnings.append("StandPoint is null");
	return warnings;

