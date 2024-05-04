class_name SpawnPoint
extends Node3D

@export var hide : bool = false;
@export var index : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = not hide;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
