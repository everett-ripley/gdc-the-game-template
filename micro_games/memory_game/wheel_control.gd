extends Node2D
signal lock_answer(answer_pattern:String)

@onready var wheels : Array = [
	$LetterWheel, $LetterWheel2, $LetterWheel3, $LetterWheel4, $LetterWheel5
]
const select_delay_time : float = 0.1
var select_delay_timer : float = select_delay_time:
	set(new):
		can_change_selection = false
		if new >= select_delay_time:
			can_change_selection = true
			select_delay_timer = 0
		else:
			select_delay_timer = new
var can_change_selection : bool = true
var disabled : bool = false

var index : int = 0:
	set(new):
		can_change_selection = false
		wheels[index].is_selected = false
		if new > 4: new = 0
		elif new < 0: new = 4
		index = new
		wheels[index].is_selected = true

func _ready():
	wheels = get_children()
	wheels[index].is_selected = true

func _input(event):
	if disabled == true:return
	if event is InputEventKey:
		if event.pressed:
			#if event.keycode == KEY_SPACE:
			#	confirm_pattern()
			if !can_change_selection:return
			elif event.keycode == KEY_A:
				index -= 1
			elif event.keycode == KEY_D:
				index += 1

func _process(delta):
	if !can_change_selection:
		select_delay_timer += delta

func confirm_pattern():
	var ans_str : String
	for w in wheels:
		w.lock()
		ans_str += w.get_character()
	lock_answer.emit(ans_str)
	disabled = true
	

func disable():
	disabled = true
	hide()
	for w in wheels:
		w.lock()

func animate_comparison(pattern:String):
	if len(pattern) != 5:return
	for i in range(5):
		wheels[i].check_correctness(pattern[i])
		await get_tree().create_timer(0.2).timeout
