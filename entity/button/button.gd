class_name FloorButton
extends Node3D

@export var sticky : bool = false:
	set(value):
		sticky = value;
		_update_graphics();

var triggered: bool = false;

signal on_trigger(area: Area3D);
signal on_untrigger(area: Area3D);

var touching_this_button: Array[Area3D] = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_graphics();


func _on_area_3d_area_entered(area):
	if area.name == "CharacterHitbox":
		if not touching_this_button.has(area):
			touching_this_button.append(area);
		triggered = touching_this_button.size() > 0;
		_update_graphics();
		on_trigger.emit(area);


func _on_area_3d_area_exited(area):
	if area.name == "CharacterHitbox":
		var index = touching_this_button.find(area);
		if index != -1:
			touching_this_button.remove_at(index);
		triggered = (sticky and triggered) or touching_this_button.size() > 0;
		_update_graphics();
		if not triggered:
			on_untrigger.emit(area);

func _update_graphics():
	if triggered:
		$ButtonDown.visible = true;
		$ButtonUp.visible = false;
		$ButtonUpSticky.visible = false;
	else:
		$ButtonDown.visible = false;
		$ButtonUp.visible = not sticky;
		$ButtonUpSticky.visible = sticky;
	#$PushIndicator.visible = not triggered and not sticky;
	#$StickyIndicator.visible = not triggered and sticky;
