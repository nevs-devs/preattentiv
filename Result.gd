extends Node2D

func _ready():
	$"Yes".connect("pressed", self, "yes_clicked")
	$"No".connect("pressed", self, "no_clicked")
	$"Maybe".connect("pressed", self, "maybe_clicked")

func yes_clicked():
	print('yes clicked')
	get_node("/root/Main").next_round()

func no_clicked():
	print('no clicked')
	get_node("/root/Main").next_round()

func maybe_clicked():
	print('maybe clicked')
	get_node("/root/Main").next_round()
