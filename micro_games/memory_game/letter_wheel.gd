extends Path2D

const scroll_time : float = 0.3

@onready var focus_square := $FocusSquare

@onready var path_follows := [
	$PathFollow2D, $PathFollow2D2, $PathFollow2D3, $PathFollow2D4
]

var change_symbol_sound : AudioStreamPlayer

var characters : Array[String] = [
	"A", "B", "C", "D"
]

var index : int = 2:
	set(new):
		if new > 3: new = 0
		elif new < 0: new = 3
		scroll_wheel(index, new)
		index = new

var is_scrolling : bool = false
var is_selected : bool = false:
	set(new):
		if is_locked:return
		is_selected = new
		if is_selected:
			focus_square.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			focus_square.modulate = Color(1,1,1,0.5)
var is_locked : bool = false

func _ready():
	path_follows[0].modulate.a = 0.0

func _input(event):
	if is_locked:return
	if !is_selected:return
	if is_scrolling:return
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_W:
				index += 1
			if event.keycode == KEY_S:
				index -= 1

func scroll_wheel(old:int, new:int):
	is_scrolling = true
	
	if change_symbol_sound != null:
		var p : float = randf_range(0.95, 1.05)
		change_symbol_sound.pitch_scale = p
		change_symbol_sound.play()
	
	var difference : float = 0.5 - path_follows[new].progress_ratio
	
	var t := create_tween()
	for pf in path_follows:
		var new_pr : float = pf.progress_ratio + difference
		if new_pr > 1.0:
			new_pr -= 1.0
		elif new_pr < 0.0:
			new_pr += 1.0
		var distance : float = abs(new_pr - 0.5) * 2
		t.parallel().tween_property(pf, "modulate", Color(1,1,1, 1 - distance), scroll_time)
		t.parallel().tween_property(pf, "progress_ratio", pf.progress_ratio + difference, scroll_time)
	
	await t.finished
	is_scrolling = false
	print(get_character())
	

func get_character()->String:
	return characters[index]

func lock():
	is_locked = true
	var t := create_tween()
	for i in range(0, 4):
		if i != index:
			t.parallel().tween_property(path_follows[i], "modulate", Color(1,1,1,0), 0.2)
	focus_square.modulate = Color(1,1,1,1)

func check_correctness(sym:String)->bool:
	if sym == get_character():
		focus_square.modulate = Color(0,1,0,1)
		return true
	else:
		focus_square.modulate = Color(1,0,0,1)
		return false
