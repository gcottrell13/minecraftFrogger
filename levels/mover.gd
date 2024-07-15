@tool
class_name Mover
extends Path3D

@export var speed : float = 1;
@export var offset_distance : float = 0;
@export var active : bool = true;
@export var editor_tool : bool = true;

@export var loop : bool:
	set(value):
		loop = value;
		_reset();
		
@export var time_offset : float:
	set(value):
		time_offset = value;
		_reset();

@export var remove_when_done : bool = false;

@export var length : float = 0;

@onready var pathFollow : PathFollow3D = $PathFollow3D;
var offset_progress : float = 0;

func _reset():
	if pathFollow == null:
		return;
	pathFollow.progress = 0;
	offset_progress = 0;
	if not loop:
		pathFollow.visible = false;
		pathFollow.process_mode = Node.PROCESS_MODE_DISABLED;
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if pathFollow != null:
		if time_offset:
			pathFollow.visible = false;
			pathFollow.process_mode = Node.PROCESS_MODE_DISABLED;
			offset_progress = 0;
		pathFollow.progress = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pathFollow == null or not active:
		return;
	if Engine.is_editor_hint() and not editor_tool:
		return;
	length = curve.get_baked_length();
	if length == 0:
		return;
	if loop:
		pathFollow.progress = fmod(Time.get_unix_time_from_system() * speed + offset_distance, length);
	elif offset_progress >= time_offset and not pathFollow.visible:
		pathFollow.visible = true;
		pathFollow.process_mode = Node.PROCESS_MODE_INHERIT;
	elif offset_progress < time_offset:
		offset_progress += delta;
	elif pathFollow.progress <= length and pathFollow.progress >= 0:
		pathFollow.progress = clampf(pathFollow.progress + speed * delta, 0, length);
	elif remove_when_done and owner == null:
		get_parent().remove_child(self);
