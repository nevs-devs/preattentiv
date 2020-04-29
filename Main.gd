extends Node2D

class Experiment:
	var subject
	var distractors
	var count
	var description
	var result_description

	func _init(subject, distractors, count, description, result_description):
		self.subject = subject
		self.distractors = distractors
		self.count = count
		self.description = description
		self.result_description = result_description

const COUNTDOWN_TIME = 3
const NUM_CYCLES = 2

const EXPLANATION_MODE = 0
const COUNTDOWN_MODE = 1
const SHOW_MODE = 2
const RESULT_MODE = 3

const DURATIONS = [4.0, 2.0, 1.5, 1.0, 0.75, 0.5, 0.375, 0.25, 0.125, 0.075]
var EXPERIMENTS = []

var mode = EXPLANATION_MODE
var time_counter = 0

var subject_included = false
var cycle_answers_right = []
var all_cycle_answers_right = []

var experiment_index = 0
var duration_index = 0
var cycle_index = 0

func setup_experiments():
	EXPERIMENTS = [
		Experiment.new("motion", ["size1"], 40, "Zeigt das Bild ein sich bewegendes Viereck?", "Gab es ein sich bewegendes Viereck?"),
		Experiment.new("red_circle", ["blue_circle"], 40, "Zeigt das Bild einen roten Punkt?", "Gab es einen roten Punkt?")
	]

func _ready():
	setup_experiments()
	start_explanation()

func get_current_experiment() -> Experiment:
	return EXPERIMENTS[experiment_index]

func start_explanation():
	var current_experiment = get_current_experiment()
	$"Explanation/InfoPanel/DurationLabel".text = "Dauer: " + str(int(1000*DURATIONS[duration_index])) + " ms"
	$"Explanation/InfoPanel/CycleLabel".text = "Durchgang: " + str(cycle_index + 1) + "/" + str(NUM_CYCLES)
	$"Explanation/InfoPanel/ExperimentLabel".text = "Experiment: " + str(experiment_index + 1) + "/" + str(len(EXPERIMENTS))
	$"Explanation/Label".text = current_experiment.description
	$"Result/Description".text = current_experiment.result_description
	$"Show".visible = true
	$"Countdown".visible = false
	$"Explanation".visible = true
	$"Result".visible = false
	mode = EXPLANATION_MODE
	$"Show".clear()
	$"Show".show_objects(current_experiment.subject, current_experiment.distractors, current_experiment.count, true)

	# setup round
	subject_included = bool(randi() % 2)

func start_countdown():
	$"Countdown".visible = true
	$"Explanation".visible = false
	$"Show".visible = false
	$"Result".visible = false
	$"Show".clear()
	var current_experiment = get_current_experiment()
	$"Show".show_objects(current_experiment.subject, current_experiment.distractors, current_experiment.count, subject_included)
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

func inc_cycle_index():
	cycle_index += 1
	if cycle_index >= NUM_CYCLES:
		# manage cycle answers
		all_cycle_answers_right.append(cycle_answers_right)
		var num_right_wrong_answers = get_num_right_wrong_answers(cycle_answers_right)
		cycle_answers_right = []
		cycle_index = 0
		if num_right_wrong_answers[1] >= 2:
			duration_index = 0
			inc_experiment_index()
		else:
			inc_duration_index()

func inc_duration_index():
	duration_index += 1
	if duration_index >= len(DURATIONS):
		duration_index = 0
		inc_experiment_index()

func inc_experiment_index():
	experiment_index += 1
	if experiment_index >= len(EXPERIMENTS):
		print('finished. Results:')
		print(all_cycle_answers_right)

func next_round(answer):
	var answer_right = false
	if answer is bool:
		answer_right = (answer == subject_included)
		print('answer: ', answer, '  subject included: ', subject_included)
	cycle_answers_right.append(answer_right)

	inc_cycle_index()
	if not experiment_index >= len(EXPERIMENTS):
		start_explanation()

func get_num_right_wrong_answers(answers):
	var num_right_answers = 0
	var num_wrong_answers = 0
	for answer in answers:
		if answer:
			num_right_answers += 1
		else:
			num_wrong_answers += 1

	return [num_right_answers, num_wrong_answers]
