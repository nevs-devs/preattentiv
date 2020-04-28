extends Sprite

var _elapsed_time: float = 0
var _initial_pos: Vector2
var is_moving: bool

func _ready() -> void:
	_initial_pos = position
	
func _process(delta) -> void:
	_elapsed_time += delta
	if is_moving:
		position = _initial_pos + Vector2(0.0, sin(_elapsed_time * 20.0) * 5.0)
