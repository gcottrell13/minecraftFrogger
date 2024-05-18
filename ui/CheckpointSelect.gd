class_name CheckpointSelect
extends Control

signal item_activated(index: int);

@onready var itemlist: ItemList = $VBoxContainer/ItemList;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_items(items: Array[String]):
	itemlist.clear();
	for item in items:
		itemlist.add_item(item, null, false);


func _on_item_list_item_activated(index):
	item_activated.emit(index);


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	item_activated.emit(index);
