extends Sprite

var initial_pos: Vector2
var is_moving: bool

func _ready() -> void:
	initial_pos = position
	
func _process(delta) -> void:
	if is_moving:
		pass
