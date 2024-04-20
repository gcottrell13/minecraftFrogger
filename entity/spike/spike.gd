@tool
class_name Spike
extends Node3D

var state = 0;

## the number of seconds to wait before starting the cycle
@export var offset_seconds: float = 0;

## the number of seconds to remain idle after retracting.
@export var idle_seconds: float = 5;

## the amount of time to telegraph that the spikes are about to arrive.
@export var telegraph_seconds: float = 1;

## the amount of time to remain extended and deadly.
@export var extended_seconds: float = 2;

@onready var timer: Timer = $Timer;

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = offset_seconds;
	$idle.visible = true;
	$telegraph.visible = false;
	$spike.visible = false;
	state = 2;
	timer.start();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	match state:
		0:
			$idle.visible = false;
			$telegraph.visible = true;
			timer.wait_time = telegraph_seconds;
			state = 1;
		1:
			$telegraph.visible = false;
			$spike.visible = true;
			timer.wait_time = extended_seconds;
			state = 2;
		2:
			$spike.visible = false;
			$idle.visible = true;
			timer.wait_time = idle_seconds;
			state = 0;
	timer.start();
