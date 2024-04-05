class_name SolidBlock
extends BaseBlock

func _ready():
	super();
	for child in get_children():
		if child is RayCast3D:
			child.add_exception($collision);

func _process(delta):
	super(delta);
	for child in get_children():
		if child is RayCast3D:
			if not child.enabled:
				continue;
			var collider: Node3D = child.get_collider();
			if collider == null:
				continue;
			var parent = collider.get_parent();
			if parent is BaseCharacter:
				parent.on_collide_with_raycast(self, child, collider);
