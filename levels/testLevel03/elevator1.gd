extends Node3D

var last_known_end : float = 0;
var time_since_last_end : float = 0;

@onready var pathFollow : PathFollow3D = $PathFollow3D;
var active : bool = false;
@export var speed : float = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not active:
		time_since_last_end += delta;
		if time_since_last_end > 5:
			time_since_last_end = 0;
			active = true;
			_mult_speed(-1);
			
	if active:
		pathFollow.progress += speed * delta;
		time_since_last_end = 0;
		
	if pathFollow.progress_ratio >= 1 or pathFollow.progress_ratio <= 0:
		last_known_end = pathFollow.progress_ratio;
		active = false;


func _on_elevator_1_button_on_trigger(area):
	_mult_speed(-1);
	active = true;


func _on_elevator_1_button_on_untrigger(area):
	_mult_speed(1);
	active = true;

func _mult_speed(f=1):
	speed = f * (last_known_end * 2 - 1) * abs(speed);
