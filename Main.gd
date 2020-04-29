extends Node2D

class Experiment:
	var subject
	var distractors
	var count
	var size
	var rotation
	var description
	var result_description

	func _init(subject, distractors, count, size, rotation, description, result_description):
		self.subject = subject
		self.distractors = distractors
		self.count = count
		self.size = size
		self.rotation = rotation
		self.description = description
		self.result_description = result_description

class CycleResult:
	var experiment_index
	var user_answers
	var right_answers
	var duration
	
	func _init(experiment_index, user_answers, right_answers, duration):
		self.experiment_index = experiment_index
		self.user_answers = user_answers
		self.right_answers = right_answers
		self.duration = duration

const COUNTDOWN_TIME = 1.5
const NUM_CYCLES = 2

const EXPLANATION_MODE = 0
const COUNTDOWN_MODE = 1
const SHOW_MODE = 2
const RESULT_MODE = 3

# const DURATIONS = [4.0, 2.0, 1.5, 1.0, 0.75, 0.5, 0.375, 0.25, 0.125, 0.075]
const DURATIONS = [0.375, 0.25]
var EXPERIMENTS = []

var mode = EXPLANATION_MODE
var time_counter = 0

var subject_included = false
var cycle_user_answers = []
var cycle_right_answers = []
var cycle_results = []

var experiment_index = 0
var duration_index = 0
var cycle_index = 0

func setup_experiments():
	EXPERIMENTS = [
		Experiment.new(
			"red_circle",
			["blue_circle"],
			40,
			0.5,
			false,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, ob " +
			"sich in diesem Bild ein roter Punkt befindet.",
			"Gab es einen roten Punkt?"
		),

		Experiment.new(
			"red_circle",
			["blue_circle"],
			80,
			0.3,
			false,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, ob " +
			"sich in diesem Bild ein roter Punkt befindet.",
			"Gab es einen roten Punkt?"
		),

		Experiment.new(
			"red_circle",
			["blue_circle", "red_square"],
			40,
			0.5,
			false,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, ob " +
			"sich in diesem Bild ein roter Punkt befindet.",
		"Gab es einen roten Punkt?"
		),

		Experiment.new(
			"red_circle",
			["blue_circle", "red_square", "blue_square"],
			40,
			0.5,
			false,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, ob " +
			"sich in diesem Bild ein roter Punkt befindet.",
			"Gab es einen roten Punkt?"
		),

		Experiment.new(
			"closure2",
			["closure1"],
			40,
			0.5,
			true,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, " +
			"ob in diesem Bild ein Kreis zu sehen ist, in welchem sich ein Punkt befindet.",
			"Gab es ein Kreis der einen Punkt umschließt?"
		),

		Experiment.new(
			"motion",
			["size1"],
			40,
			0.5,
			false,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, " +
			"ob in diesem Bild ein sich bewegendes Viereck zu sehen ist.",
			"Gab es ein sich bewegendes Viereck?"
		),

		Experiment.new(
			"size1",
			["motion"],
			40,
			0.5,
			false,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, " +
			"ob in diesem Bild ein starres Viereck zu sehen ist.",
			"Gab es ein starres Viereck?"
		),

		Experiment.new(
			"size1",
			["size2"],
			40,
			0.5,
			false,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, " +
			"ob in diesem Bild ein großes Viereck zu sehen ist.",
			"Gab es ein großes Viereck?"
		),

		Experiment.new(
			"stretched1",
			["stretched2"],
			40,
			0.5,
			false,
			"Im folgenden Test wird ein Bild gezeigt. Ihre Aufgabe ist es zu erkennen, " +
			"ob in diesem Bild ein langgezogenes Rechteck zu sehen ist.",
			"Gab es ein sich langgezogenes Rechteck?"
		),
	]

func _ready():
	$"Explanation/StartButton".connect("pressed", self, "start_countdown")
	setup_experiments()
	start_explanation()

func get_current_experiment() -> Experiment:
	return EXPERIMENTS[experiment_index]

func setup_current_experiment():
	var current_experiment = get_current_experiment()

	$"Evaluation/InfoPanel/DurationLabel".text = "Dauer: " + str(int(1000*DURATIONS[duration_index])) + " ms"
	$"Evaluation/InfoPanel/CycleLabel".text = "Durchgang: " + str(cycle_index + 1) + "/" + str(NUM_CYCLES)
	$"Evaluation/InfoPanel/ExperimentLabel".text = "Experiment: " + str(experiment_index + 1) + "/" + str(len(EXPERIMENTS))
	$"Evaluation/Description".text = current_experiment.result_description

	# setup round
	subject_included = bool(randi() % 2)

func start_explanation():
	var current_experiment = get_current_experiment()
	setup_current_experiment()
	$"Explanation/Label".text = current_experiment.description
	$"Show".visible = true
	$"Countdown".visible = false
	$"Explanation".visible = true
	$"Evaluation".visible = false
	$"Results".visible = false
	mode = EXPLANATION_MODE
	$"Show".clear()
	$"Show".show_objects(
		current_experiment.subject,
		current_experiment.distractors,
		current_experiment.count,
		true,
		current_experiment.size,
		current_experiment.rotation
	)

func start_countdown():
	$"Countdown".visible = true
	$"Explanation".visible = false
	$"Show".visible = false
	$"Evaluation".visible = false
	$"Show".clear()
	setup_current_experiment()
	var current_experiment = get_current_experiment()
	$"Show".show_objects(
		current_experiment.subject,
		current_experiment.distractors,
		current_experiment.count,
		subject_included,
		current_experiment.size,
		current_experiment.rotation
	)
	time_counter = COUNTDOWN_TIME
	mode = COUNTDOWN_MODE

func start_result():
	$"Show".visible = false
	$"Countdown".visible = false
	$"Explanation".visible = false
	$"Evaluation".visible = true
	mode = RESULT_MODE

func start_show():
	$"Show".visible = true
	$"Countdown".visible = false
	$"Explanation".visible = false
	$"Evaluation".visible = false
	mode = SHOW_MODE
	time_counter = DURATIONS[duration_index]

func _input(event):
	if mode == EXPLANATION_MODE:
		if event is InputEventKey and event.pressed and event.is_action("ui_accept"):
			start_countdown()

func _process(delta):
	if mode == COUNTDOWN_MODE:
		$"Countdown/Label".text = str(min(int(time_counter*2 + 1), 3))
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
		cycle_results.append(CycleResult.new(
			experiment_index,
			cycle_user_answers.duplicate(),
			cycle_right_answers.duplicate(),
			DURATIONS[duration_index]
		))
		var num_right_wrong_answers = get_num_right_wrong_answers(cycle_user_answers, cycle_right_answers)
		cycle_user_answers.clear()
		cycle_right_answers.clear()
		cycle_index = 0
		if num_right_wrong_answers[1] >= 1:
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
		experiment_index = 0

func next_round(answer):
	cycle_user_answers.append(answer)
	cycle_right_answers.append(subject_included)

	var tmp_experiment_index = experiment_index
	inc_cycle_index()

	if tmp_experiment_index == experiment_index:
		start_countdown()
	else:
		if experiment_index == 0:
			show_result_screen()
		else:
			start_explanation()

func match_answers(user_answer, right_answer):
	if user_answer is bool:
		return user_answer == right_answer
	return false

func get_num_right_wrong_answers(cycle_user_answers, cycle_right_answers):
	var num_right_answers = 0
	var num_wrong_answers = 0
	assert(len(cycle_user_answers) == len(cycle_right_answers))
	for index in range(len(cycle_user_answers)):
		if match_answers(cycle_user_answers[index], cycle_right_answers[index]):
			num_right_answers += 1
		else:
			num_wrong_answers += 1

	return [num_right_answers, num_wrong_answers]

func mean(values):
	var sum = 0.0
	for v in values:
		sum += v
	return sum / float(len(values))

func show_result_screen():
	$Results.visible = true
	var json_results = []
	var experiment_results = []
	for _i in range(len(EXPERIMENTS)):
		experiment_results.append([0, 0])

	for cycle_result in cycle_results:
		json_results.append(
			{
				"duration": cycle_result.duration,
				"experiment_index": cycle_result.experiment_index,
				"right_answers": cycle_result.right_answers,
				"user_answers": cycle_result.user_answers
			}
		)
		var num_right_wrong_answers = get_num_right_wrong_answers(
			cycle_result.user_answers,
			cycle_result.right_answers
		)
		experiment_results[cycle_result.experiment_index][0] += num_right_wrong_answers[0]
		experiment_results[cycle_result.experiment_index][1] += num_right_wrong_answers[1]

	var experiment_percentages = []
	for experiment_result in experiment_results:
		var percentage = float(experiment_result[0]) / float(NUM_CYCLES + len(DURATIONS)) * 100.0
		experiment_percentages.append(percentage)

	$Results.set_text(JSON.print(json_results))
	$Results.set_results(experiment_percentages, mean(experiment_percentages))
