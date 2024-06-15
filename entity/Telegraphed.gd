class_name Telegraphed
extends Node

var state = 0;

## the number of seconds to wait before starting the cycle
@export var offset_seconds: float = 0;

## the number of seconds to remain idle after retracting.
@export var idle_seconds: float = 5;

## the amount of time to telegraph that the spikes are about to arrive.
@export var telegraph_seconds: float = 1;

## the amount of time to remain extended and deadly.
@export var extended_seconds: float = 2;

@export var idle : Node3D;
@export var telegraph : Node3D;
@export var active : Node3D;


# Called when the node enters the scene tree for the first time.
func _ready():
	idle.visible = true;
	telegraph.visible = false;
	active.visible = false;

func _process(delta):
	var now = int(Time.get_unix_time_from_system() - offset_seconds);
	var total = int(idle_seconds + telegraph_seconds + extended_seconds);
	var phase = now % total;
	if phase <= idle_seconds:
		state = 0;
	elif phase <= (idle_seconds + telegraph_seconds):
		state = 1;
	else:
		state = 2;
	
	idle.visible = (state == 0);
	telegraph.visible = (state == 1);
	active.visible = (state == 2);
