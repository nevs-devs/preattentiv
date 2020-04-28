extends Node2D

const MARGIN: float = 20.0

var object_scene: PackedScene = preload("res://Object.tscn")
var objects: Array = []
var width: float = 0.0
var height: float = 0.0

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
	width = $ColorRect.rect_size.x
	height = $ColorRect.rect_size.y

#func _process(delta) -> void:
#	if Input.is_action_just_pressed("ui_accept"):
#		clear()
#		show_objects("size1", ["motion"], 20, true, 0.5, false)

func _spawn_object(type: String, scaling: float, rotating: bool) -> void:
	var obj = object_scene.instance()
	obj.texture = load("res://res/" + type + ".png")
	obj.position = _random_free_position(scaling)
	obj.scale *= scaling
	obj.is_moving = "motion" in type
	if rotating:
		obj.rotate(randf() * (2 * PI))
	objects.append(obj)
	
	add_child(obj)

func _random_free_position(scaling: float) -> Vector2:
	var pos_found = false
	var pos = Vector2.ZERO
	var min_distance = 64 * scaling
	
	while not pos_found:
		pos_found = true
		
		pos = Vector2(
			randf() * (width - MARGIN - min_distance) - ((width - MARGIN - min_distance) / 2.0), 
			randf() * (height - MARGIN - min_distance) - ((height - MARGIN - min_distance) / 2.0)
		)
		
		for o in objects:
			if pos.distance_to(o.position) < min_distance:
				pos_found = false
				break
				
	return pos
