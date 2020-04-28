extends Node2D

var object_scene: PackedScene = preload("res://Object.tscn")
var objects: Array = []


func show_objects(subject: String, distractors: Array, count: int, show_subject: bool):
	if show_subject:
		_spawn_object(subject)
		
	for _ in range(count):
		_spawn_object(distractors[randi() % distractors.size()])
		
	
func clear() -> void:
	for o in objects:
		o.queue_free()
	
	objects.clear()

func _ready() -> void:
	randomize()
	
func _spawn_object(type: String) -> void:
	var obj = object_scene.instance()
	add_child(obj)
	obj.texture = load("res://res/" + type + ".png")
	obj.position = _random_free_position()
	objects.append(obj)

func _random_free_position() -> Vector2:
	var pos_found = false
	var pos = Vector2.ZERO
	
	while not pos_found:
		pos_found = true
		pos = Vector2(randf() * 368 - 184, randf() * 368 - 184)
		for o in objects:
			if pos.distance_to(o.position) < 32:
				pos_found = false
				break
				
	return pos
