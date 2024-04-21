class_name Level
extends Node3D


var manager : BlockManager;

var current_control_layer = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	manager = BlockManager.new();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func register_children():
	if manager == null:
		manager = BlockManager.new();
	for child in get_children():
		if child is BaseBlock:
			manager.register_block(Vector3i(child.position), child);

func get_neighbors(vec: Vector3i) -> Array[BaseBlock]:
	return manager.get_neighbors(vec);

func _unhandled_input(event: InputEvent):
	var current_camera: Camera3D = get_viewport().get_camera_3d();
	if current_camera == null:
		return;
	
	var handled = false;
		
	if event is InputEventKey:
		if not event.pressed or event.is_echo():
			return;
		
		var vec = Vector3(Input.get_axis("Left", "Right"), Input.get_axis("Down", "Up"), 0);
		var delta = current_camera.to_global(vec) - current_camera.global_position;
		
		var controllables: Array[Node3D] = ControllableManager.get_controllables(get_tree(), current_control_layer);
		for controllable in controllables:
			if not self.is_ancestor_of(controllable):
				continue;
			if controllable is BaseCharacter:
				if event.is_action("Jump"):
					controllable.do_special();
				else:
					var dir = controllable.to_local(delta + controllable.global_position);
					dir = Vector3(dir.x, 0, dir.z);
					if abs(dir.x) > abs(dir.z):
						controllable.move_character(Vector3(sign(dir.x), 0, 0));
					else:
						controllable.move_character(Vector3(0, 0, sign(dir.z)));
					handled = true;
	
	if handled:
		get_viewport().set_input_as_handled();
