extends Node2D

@onready var wheels : Array = [
	$LetterWheel, $LetterWheel2, $LetterWheel3, $LetterWheel4, $LetterWheel5
]

var index : int = 0:
	set(new):
		wheels[index].is_selected = false
		if new > 4: new = 0
		elif new < 0: new = 4
		index = new
		wheels[index].is_selected = true

func _ready():
	wheels = get_children()
	wheels[index].is_selected = true

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_A:
				index -= 1
			elif event.keycode == KEY_D:
				index += 1
