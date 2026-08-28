extends MicroGame

const EMPTY : String = ""
static var pattern : String = EMPTY
static var play_count := 0
static var _hook_installed := false
static var pattern_length : int = 4

@onready var timer_label := $GoosiusLayout/Control/VerticalElementContainer/TimerContainer/TimeLabel
@onready var wheel_control := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/PanelContainer/VBoxContainer/Control/Panel/SubViewportContainer/SubViewport/Node2D/WheelControl
@onready var pattern_display := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/AnswerDisplay/VBoxContainer/HBoxContainer2/CorrectPanel/CorrectPatternDisplay
@onready var guess_display := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/AnswerDisplay/VBoxContainer/HBoxContainer2/ResponsePanel/ResponsePatternDisplay
@onready var response_panel := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/AnswerDisplay/VBoxContainer/HBoxContainer2/ResponsePanel
@onready var incorrect_answer_check := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/AnswerDisplay/VBoxContainer/HBoxContainer3/TextureContainer/IncorrectTexture
@onready var score_label := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/AnswerDisplay/VBoxContainer/HBoxContainer3/ScoreLabel
@onready var answer_display := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/AnswerDisplay
@onready var game_panel := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/PanelContainer
@onready var instructions_label := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/InstructionsLabel
@onready var question_label := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/QuestionLabel
@onready var phase_1_pattern_display := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/PatternDisplay
@onready var submit_assignment_button := $GoosiusLayout/Control/VerticalElementContainer/Control/HBoxContainer/ReferenceRect/CenterContainer/SubmitAssignmentButton
@onready var question_number_container := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/QuestionNumberContainer
@onready var section_label := $GoosiusLayout/Control/VerticalElementContainer/FilePathContaner/Section
@onready var study_spacer := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/ReferenceRect
@onready var end_game_anim := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/PuzzleContainer/EndGameAnim
@onready var question_number_label := $GoosiusLayout/Control/VerticalElementContainer/MainGameContainer/QuestionNumberContainer/HBoxContainer/QuestionNumberLabel

@export var correct_panel_style : StyleBoxFlat
@export var incorrect_panel_style : StyleBoxFlat

var time_left : float:
	set(new):
		if new <= 0:
			new = 0
			if play_count % 2 == 0:
				wheel_control.confirm_pattern()
		time_left = new
		var text : String = str(int(ceil(time_left)))
		if len(text) < 2:
			text = "0" + text
		if time_left <= 3:
			timer_label.modulate = Color(1,0,0)
		timer_label.text = text

var is_playing : bool = true


func _init() -> void:
	play_count += 1
	if not _hook_installed:
		_hook_installed = true
		if !GameManager.exit_screen.is_connected(_on_screen_exited):
			GameManager.exit_screen.connect(_on_screen_exited)

static func _on_screen_exited(screen: GameManager.Screen) -> void:
	if screen == GameManager.Screen.Game:
		play_count = 0
		_hook_installed = false
		pattern = ""

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	time_left = game_duration
	if play_count % 2 == 1: # Create Pattern
		study()
	else: # Test Pattern
		test()

func _process(delta):
	if time_left > 0 and is_playing:
		time_left -= delta


func study():
	game_panel.hide()
	answer_display.hide()
	question_label.hide()
	study_spacer.custom_minimum_size.x += 350
	section_label.text = "Notes"
	question_number_container.hide()
	submit_assignment_button.hide()
	wheel_control.disable()
	pattern = generate_pattern()
	phase_1_pattern_display.display_pattern(pattern)
	post_game_time = 0.0

func test():
	var question_number : int = play_count / 2
	question_number_label.text = str(question_number)
	instructions_label.hide()
	answer_display.hide()


func generate_pattern()->String:
	var symbols : Array[String] = ["A", "B", "C", "D"]
	var p : String = ""
	for i in range(5):
		p += symbols.pick_random()
	return p


func _on_wheel_control_lock_answer(answer_pattern:String):
	#timer_label.hide()
	#time_left = 9999999.0
	#pattern_anim.play("reveal_pattern")
	pattern_display.show()
	pattern_display.display_pattern(pattern)
	submit_assignment_button.disabled = true
	end_game_anim.play("end_game")
	pattern_display.display_pattern(pattern)
	guess_display.display_pattern(answer_pattern)
	#wheel_control.animate_comparison(pattern)
	if answer_pattern == pattern:
		print("Win!")
		win.emit()
	else:
		print("Lose!")
		lose.emit()


func _on_submit_assignment_button_pressed():
	wheel_control.confirm_pattern()


func _on_lose():
	is_playing = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	response_panel.add_theme_stylebox_override("panel", incorrect_panel_style)


func _on_win():
	is_playing = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	response_panel.add_theme_stylebox_override("panel", correct_panel_style)
	score_label.text = "1"
	incorrect_answer_check.hide()
