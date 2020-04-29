extends Node2D

func _ready():
	$"Yes".connect("pressed", self, "yes_clicked")
	$"No".connect("pressed", self, "no_clicked")
	$"Maybe".connect("pressed", self, "maybe_clicked")

func yes_clicked():
	get_node("/root/Main").next_round(true)

func no_clicked():
	get_node("/root/Main").next_round(false)

func maybe_clicked():
	get_node("/root/Main").next_round("maybe")
