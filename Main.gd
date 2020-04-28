extends Node2D

const COUNTDOWN_TIME = 3

const EXPLANATION_MODE = 0
const COUNTDOWN_MODE = 1
const SHOW_MODE = 2
const RESULT_MODE = 3

var mode = EXPLANATION_MODE

var time_counter = 0
var duration = 1

func _ready():
	start_explanation()

func start_explanation():
	print('start explanation')
	$"Show".visible = true
	$"Countdown".visible = false
	$"Explanation".visible = true
	$"Result".visible = false
	mode = EXPLANATION_MODE
	# $"Show".show_objects("subject", ["distractor1", "distractor2"], count=10, show_subject=True)

func start_countdown():
	print('start countdown')
	$"Countdown".visible = true
	$"Explanation".visible = false
	time_counter = COUNTDOWN_TIME
	mode = COUNTDOWN_MODE

func start_result():
	print('result')
	$"Show".visible = false
	$"Countdown".visible = false
	$"Explanation".visible = false
	$"Result".visible = true
	mode = RESULT_MODE

func start_show():
	print('start show')
	$"Show".visible = true
	$"Countdown".visible = false
	$"Explanation".visible = false
	$"Result".visible = false
	mode = SHOW_MODE
	time_counter = duration

func _input(event):
	if mode == EXPLANATION_MODE:
		if event is InputEventKey and event.pressed and event.is_action("ui_accept"):
			start_countdown()

func _process(delta):
	if mode == COUNTDOWN_MODE:
		time_counter -= delta
		if time_counter <= 0:
			start_show()
	if mode == SHOW_MODE:
		time_counter -= delta
		if time_counter <= 0:
			start_result()

func next_round():
	print('next round')
	start_explanation()
