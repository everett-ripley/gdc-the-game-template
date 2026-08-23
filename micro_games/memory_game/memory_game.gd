extends MicroGame

const EMPTY : String = ""
static var pattern : String = EMPTY
static var play_count := 0
static var _hook_installed := false
static var pattern_length : int = 4

@onready var study_label := $HUD/Control/HBoxContainer/Instructions/StudyLabel
@onready var test_label := $HUD/Control/HBoxContainer/Instructions/TestLabel
@onready var timer_label := $HUD/Control/HBoxContainer/Timer/TimerLabel


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
	if play_count % 2 == 1: # Create Pattern
		study()
	else: # Test Pattern
		test()

func study():
	study_label.show()

func test():
	test_label.show()
