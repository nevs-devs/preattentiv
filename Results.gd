extends Node2D

func set_text(text: String) -> void:
	$TextEdit.text = text

func set_results(results: Array) -> void:
	pass
	

func _on_Close_pressed():
	get_tree().quit()
