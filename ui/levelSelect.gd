@tool
extends Control

signal on_click_level(scene: PackedScene);

@onready var vbox: Control = $VBoxContainer;

@export var levels : Array[PackedScene] = []:
	set = _set_levels;

# Called when the node enters the scene tree for the first time.
func _ready():
	fix_children();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _set_levels(value):
	levels = value;
	
	if Engine.is_editor_hint():
		fix_children();

func fix_children():
	for child in vbox.get_children():
		vbox.remove_child(child);
	
	for scene in levels:
		if scene == null:
			continue;
		var v1 : PackedScene = scene;
		print(v1.resource_path);
			
		var button = LevelSelectButton.new(v1.resource_path);
		button.name = v1.resource_path;
		button.text = v1.resource_path;
		button.button_pressed_value.connect(_button_pressed, CONNECT_PERSIST);
		vbox.add_child(button);
		button.owner = self;

func _button_pressed(value):
	on_click_level.emit(load(value));

