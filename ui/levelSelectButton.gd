class_name LevelSelectButton
extends Button


signal button_pressed_value(value: String);

var value: String;

func _init(v: String):
	value = v;

func _ready():
	focus_mode = Control.FOCUS_NONE;
	pressed.connect(on_press, CONNECT_PERSIST);

func on_press():
	button_pressed_value.emit(value);
