extends MicroGame

const START_Y : float = 0.0
const END_Y : float = 158.0

@onready var lake_pivot := $CanvasLayer/LakePivot
@onready var background_sound := $Background
@onready var straw_sound := $Straw

@export var percent_per_press : float = 0.05:
	set(new):
		percent_per_press = clamp(new, 0.0, 1.0)

@export var audio_stop_time : float = 0.25
var audio_timer : float = 0.0

var distance_per_press : float = 0.0
var lake_pos : float = 0.0:
	set(new):
		if new >= END_Y:
			win.emit()
		lake_pos = clamp(new, START_Y, END_Y)
		lake_pivot.position.y = lake_pos

var is_drinking : bool = false:
	set(new):
		is_drinking = new
		straw_sound.stream_paused = !is_drinking
		background_sound.stream_paused = is_drinking

func _ready():
	distance_per_press = (END_Y - START_Y) * percent_per_press
	straw_sound.stream_paused = true

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			lake_pos += distance_per_press
			is_drinking = true
			audio_timer = 0.0

func _process(delta):
	if audio_timer < audio_stop_time:
		audio_timer += delta
	else:
		is_drinking = false
