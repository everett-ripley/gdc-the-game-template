extends Path2D

const scroll_time : float = 0.3

@onready var focus_square := $FocusSquare

@onready var path_follows := [
	$PathFollow2D, $PathFollow2D2, $PathFollow2D3, $PathFollow2D4
]
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
		is_selected = new
		if is_selected:
			focus_square.modulate.a = 1.0
		else:
			focus_square.modulate.a = 0.5

func _ready():
	path_follows[0].modulate.a = 0.0

func _input(event):
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
		
		#if is_equal_approx(pf.progress_ratio + difference, 1.0) or is_equal_approx(pf.progress_ratio + difference, 0):
		#	t.parallel().tween_property(pf, "modulate", Color(1,1,1,0), scroll_time)
		#else:
		#	t.parallel().tween_property(pf, "modulate", Color(1,1,1,1), scroll_time)
		t.parallel().tween_property(pf, "progress_ratio", pf.progress_ratio + difference, scroll_time)
	
	await t.finished
	is_scrolling = false
	print(get_character())
	

func get_character()->String:
	return characters[index]
