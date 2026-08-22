extends MicroGame

const START_Y : float = 0.0
const END_Y : float = 158.0

@onready var lake_pivot := $CanvasLayer/LakePivot
@onready var background_sound := $Background
@onready var straw_sound := $Straw
@onready var straw_image := $CanvasLayer/Control/StrawImage
@onready var time_label := $HUD/Control/TimeLabel

@export var percent_per_press : float = 0.05:
	set(new):
		percent_per_press = clamp(new, 0.0, 1.0)

@export var audio_stop_time : float = 0.25
var audio_timer : float = 0.0
var time_left : float = 10.0

var has_won : bool = false:
	set(new):
		has_won = new
		is_drinking = false

var has_lost : bool = false

var distance_per_press : float = 0.0
var lake_pos : float = 0.0:
	set(new):
		if has_won:return
		if new >= END_Y:
			win.emit()
			resume_music.emit()
			has_won = true
		lake_pos = clamp(new, START_Y, END_Y)
		lake_pivot.position.y = lake_pos

var is_drinking : bool = false:
	set(new):
		if has_won: new = false
		is_drinking = new
		straw_sound.stream_paused = !is_drinking
		background_sound.stream_paused = is_drinking
		straw_image.visible = is_drinking
		if is_drinking: resume_music.emit()
		else: pause_music.emit()

func _ready():
	time_left = game_duration
	distance_per_press = (END_Y - START_Y) * percent_per_press
	straw_sound.stream_paused = true
	pause_music.emit()

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			lake_pos += distance_per_press
			is_drinking = true
			audio_timer = 0.0

func _process(delta):
	if !has_won and !has_lost:
		time_left -= delta
		time_label.text = str(int(ceil(time_left)))
	
	if audio_timer < audio_stop_time:
		audio_timer += delta
	else:
		is_drinking = false


func _on_lose():
	has_lost = true
	resume_music.emit()
