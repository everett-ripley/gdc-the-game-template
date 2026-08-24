extends MicroGame

const EMPTY : String = ""
static var pattern : String = EMPTY
static var play_count := 0
static var _hook_installed := false
static var pattern_length : int = 4

@onready var study_label := $HUD/Control/HBoxContainer/Instructions/StudyLabel
@onready var test_label := $HUD/Control/HBoxContainer/Instructions/TestLabel
@onready var timer_label := $HUD/Control/HBoxContainer/Timer/TimerLabel
@onready var wheel_control := $Pattern/WheelControl
@onready var pattern_display := $Pattern/PatternDisplay
@onready var pattern_anim := $Pattern/PatternAnim

var time_left : float:
	set(new):
		if new <= 0:
			timer_label.hide()
			new = 0
			if play_count % 2 == 0:
				wheel_control.confirm_pattern()
		time_left = new
		timer_label.text = str(int(ceil(time_left)))


func _init() -> void:
	play_count += 1
	if not _hook_installed:
		_hook_installed = true
		GameManager.exit_screen.connect(_on_screen_exited)

static func _on_screen_exited(screen: GameManager.Screen) -> void:
	if screen == GameManager.Screen.Game:
		play_count = 0
		_hook_installed = false
		pattern = ""

func _ready():
	time_left = game_duration
	if play_count % 2 == 1: # Create Pattern
		study()
	else: # Test Pattern
		test()

func _process(delta):
	if time_left > 0:
		time_left -= delta


func study():
	study_label.show()
	wheel_control.disable()
	pattern = generate_pattern()
	pattern_display.display_pattern(pattern)
	post_game_time = 0.0

func test():
	test_label.show()


func generate_pattern()->String:
	var symbols : Array[String] = ["A", "B", "C", "D"]
	var p : String = ""
	for i in range(5):
		p += symbols.pick_random()
	return p


func _on_wheel_control_lock_answer(answer_pattern:String):
	timer_label.hide()
	time_left = 9999999.0
	pattern_anim.play("reveal_pattern")
	pattern_display.show()
	pattern_display.display_pattern(pattern)
	wheel_control.animate_comparison(pattern)
	if answer_pattern == pattern:
		print("Win!")
		win.emit()
	else:
		print("Lose!")
		lose.emit()
