class_name Level
extends Node3D


var manager : BlockManager;

var current_control_layer = 0;
@export var last_checkpoint_index = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	manager = BlockManager.new();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		return;
	if ControllableManager.get_controllables(get_tree(), -1).size() == 0:
		_on_no_controllables_left();

func _on_no_controllables_left():
	pass

func register_children():
	if manager == null:
		manager = BlockManager.new();
	for child in get_children():
		if child is BaseBlock:
			manager.register_block(child.position, child);

func get_neighbors(vec: Vector3) -> Array[BaseBlock]:
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
		
		var controllables: Array[Node] = ControllableManager.get_controllables(get_tree(), current_control_layer);
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


func on_fadetoblack_end(anim: FadeToBlackAnimation):
	remove_child(anim);
	fade_to(get_viewport().get_camera_3d(), on_fadefromblack_end, 1);
	

func on_fadefromblack_end(anim: FadeToBlackAnimation):
	remove_child(anim);


func fade_to(camera: Camera3D, handler, target_fade: float):
	var fade = FadeToBlackAnimation.new(camera, 1, target_fade);
	add_child(fade);
	fade.done.connect(handler);

func spawn_characters_from_save(char_scene: PackedScene):
	spawn_characters(last_checkpoint_index, char_scene);

func spawn_characters(index: int, char_scene: PackedScene):
	for child in find_children("", "SpawnPoint"):
		if child.index != index:
			continue;
		var spawn_children: Array[Node] = child.get_children();
		var frog: Node3D = char_scene.instantiate();
		add_child(frog);
		frog.position = child.position;
		frog.rotation = child.rotation;
		ControllableManager.set_controllable(frog, 0);
		for spawnchild in spawn_children:
			if spawnchild.owner != self:
				continue;
			var dup = spawnchild.duplicate();
			dup.process_mode = Node.PROCESS_MODE_INHERIT;
			frog.add_child(dup);
			if spawnchild is Camera3D:
				CameraManager.add_camera_target(dup, 0);
				fade_to(dup, on_fadefromblack_end, 1);
