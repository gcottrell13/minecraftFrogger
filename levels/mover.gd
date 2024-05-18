@tool
class_name Mover
extends Path3D

@export var speed : float = 1;
@export var active : bool = true;
@export var editor_tool : bool = true;

var pathFollow : PathFollow3D;


# Called when the node enters the scene tree for the first time.
func _ready():
	pathFollow = find_child("PathFollow3D");
	if pathFollow != null:
		pathFollow.progress = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pathFollow == null or not active:
		return;
	if Engine.is_editor_hint() and not editor_tool:
		return;
	var length = curve.get_baked_length();
	if length == 0:
		return;
	pathFollow.progress = fmod(Time.get_unix_time_from_system(), length) * speed;
