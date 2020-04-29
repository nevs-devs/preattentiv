extends Node2D

func set_text(text: String) -> void:
	$TextEdit.text = text

func set_results(results: Array) -> void:
	$Exp1.text = "Exp. 01: %3.2f%%\nExp. 02: %3.2f%%\nExp. 03: %3.2f%%\nExp. 04: %3.2f%%" % [results[0], results[1], results[2], results[3]]
	$Exp2.text = "Exp. 05: %3.2f%%\nExp. 06: %3.2f%%\nExp. 07: %3.2f%%\nExp. 08: %3.2f%%" % [results[4], results[5], results[6], results[7]]
	$Exp3.text = "Exp. 09: %3.2f%%\nExp. 10: %3.2f%%\nExp. 11: %3.2f%%\nGesamt: %3.2f%%" % [results[8], results[9], results[10], results[11]]

func _on_Close_pressed():
	get_tree().quit()
