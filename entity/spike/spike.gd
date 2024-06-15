@tool
class_name Spike
extends Telegraphed

@onready var hitbox: Area3D = $Area3D;

# Called when the node enters the scene tree for the first time.
func _ready():
	super();
	hitbox.monitoring = false;

func _process(delta):
	super(delta);
	hitbox.monitoring = (state == 2);

func _on_area_3d_area_entered(area: Area3D):
	if area.name == "CharacterHitbox":
		var p = area.get_parent();
		if p is BaseCharacter:
			p.die(BaseCharacter.DAMAGE_SOURCE.Cleaved);
