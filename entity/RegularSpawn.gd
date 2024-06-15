@tool
class_name RegularSpawn
extends Node3D

@export var active : bool = true;

@export var template_node : Node3D;

@export var offset_seconds : float = 0;
@export var interval_seconds : float = 1;

var progress = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not active:
		return;
		
	var next = fmod(Time.get_unix_time_from_system() - offset_seconds, interval_seconds);
	
	if template_node == null:
		return;
		
	if next < progress:
		var duplicate : Node3D = template_node.duplicate();
		if duplicate is Mover:
			duplicate.active = true;
		get_parent().add_child(duplicate);
		duplicate.position = position;
		
	progress = next;
