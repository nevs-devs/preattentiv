extends Node2D

const EXPLANATION_MODE = 0
const COUNTDOWN_MODE = 1
const SHOW_MODE = 2
const RESULT_MODE = 3

var mode = EXPLANATION_MODE

func _ready():
	pass

func show_explanation():
	$"Countdown".visible = false
	$"Explanation".visible = true
	$"Show".create("mode")
