extends Node2D

var object_scene: PackedScene = preload("res://Object.tscn")
var objects: Array = []

func show_objects(subject: String, distractors: Array, count: int, show_subject: bool = true, scaling: float = 0.5, rotating: bool = false):
	if show_subject:
		_spawn_object(subject, scaling, rotating)
		
	for _i in range(count):
		_spawn_object(distractors[randi() % distractors.size()], scaling, rotating)
		
	
func clear() -> void:
	for o in objects:
		o.queue_free()
	
	objects.clear()

func _ready() -> void:
	randomize()

func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		clear()
		show_objects("stretched1", ["stretched2"], 20, true, 0.5, false)
		
func _spawn_object(type: String, scaling: float, rotating: bool) -> void:
	var obj = object_scene.instance()
	add_child(obj)
	obj.texture = load("res://res/" + type + ".png")
	obj.position = _random_free_position(scaling)
	obj.scale *= scaling
	obj.is_moving = "motion" in type
	if rotating:
		obj.rotate(randf() * (2 * PI))
	objects.append(obj)

func _random_free_position(scaling: float) -> Vector2:
	var pos_found = false
	var pos = Vector2.ZERO
	var margin = 64 * scaling
	
	while not pos_found:
		pos_found = true
		pos = Vector2(randf() * (400 - margin) - (200 - margin / 2.0), randf() * (400 - margin) - (200 - margin / 2.0))
		for o in objects:
			if pos.distance_to(o.position) < margin:
				pos_found = false
				break
				
	return pos
