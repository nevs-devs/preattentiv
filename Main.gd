extends Node2D

const COUNTDOWN_TIME = 3

const EXPLANATION_MODE = 0
const COUNTDOWN_MODE = 1
const SHOW_MODE = 2
const RESULT_MODE = 3

const DURATIONS = [0.075, 0.125, 0.25, 0.375, 0.5, 0.75, 1.0, 1.5, 2.0, 4.0]

var mode = EXPLANATION_MODE

var time_counter = 0

var duration_index = 0

func _ready():
	start_explanation()

func start_explanation():
	$"Show".visible = true
	$"Countdown".visible = false
	$"Explanation".visible = true
	$"Result".visible = false
	mode = EXPLANATION_MODE
	$"Show".clear()
	$"Show".show_objects("red_circle", ["blue_circle"], 40, true)

func start_countdown():
	$"Countdown".visible = true
	$"Explanation".visible = false
	$"Show".visible = false
	$"Result".visible = false
	$"Show".clear()
	$"Show".show_objects("red_circle", ["blue_circle"], 40, true)
	time_counter = COUNTDOWN_TIME
	mode = COUNTDOWN_MODE

func start_result():
	$"Show".visible = false
	$"Countdown".visible = false
	$"Explanation".visible = false
	$"Result".visible = true
	mode = RESULT_MODE

func start_show():
	$"Show".visible = true
	$"Countdown".visible = false
	$"Explanation".visible = false
	$"Result".visible = false
	mode = SHOW_MODE
	time_counter = DURATIONS[duration_index]

func _input(event):
	if mode == EXPLANATION_MODE:
		if event is InputEventKey and event.pressed and event.is_action("ui_accept"):
			start_countdown()

func _process(delta):
	if mode == COUNTDOWN_MODE:
		$"Countdown/Label".text = str(min(int(time_counter + 1), 3))
		time_counter -= delta
		if time_counter <= 0:
			start_show()
	if mode == SHOW_MODE:
		time_counter -= delta
		if time_counter <= 0:
			start_result()

func next_round():
	start_explanation()
