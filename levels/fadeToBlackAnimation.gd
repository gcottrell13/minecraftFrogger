class_name FadeToBlackAnimation
extends Node

var target_camera: Camera3D;
var time_seconds: float;
var target_value: float;
var progress: float;
var _done: bool;

signal done(me: FadeToBlackAnimation);


func _init(camera: Camera3D, seconds: float, at_value: float = 0):
	time_seconds = seconds;
	progress = 0;
	_done = false;
	target_value = at_value;
	target_camera = camera;
	if target_camera.environment == null:
		_done = true;
	else:
		target_camera.environment.adjustment_brightness = 1 - target_value;
		target_camera.environment.adjustment_enabled = true;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _done:
		return;
		
	progress += delta;
	if progress >= time_seconds:
		done.emit(self);
		target_camera.environment.adjustment_brightness = target_value;
		_done = true;
	else:
		target_camera.environment.adjustment_brightness = move_toward(target_camera.environment.adjustment_brightness, target_value, delta / time_seconds);
