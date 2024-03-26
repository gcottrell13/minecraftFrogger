extends Node3D

var blockdata: BlockData;

@onready var top : MeshInstance3D = $"blockrep/+Y";
@onready var bottom : MeshInstance3D = $"blockrep/-Y";
@onready var north : MeshInstance3D = $"blockrep/+Z";
@onready var south : MeshInstance3D = $"blockrep/-Z";
@onready var east : MeshInstance3D = $"blockrep/+X";
@onready var west : MeshInstance3D = $"blockrep/-X";


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
