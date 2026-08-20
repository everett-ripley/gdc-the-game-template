extends CanvasLayer
signal key_hit
signal key_missed

@onready var key_label := $Control/Key/KeyLabel
@onready var anim := $Control/AnimationPlayer
@onready var time_display := $Control/TimeDisplay

var time_left : float = 10.0:
	set(new):
		time_left = new
		time_display.set_time_left(new)

var enabled : bool = true:
	set(new):
		enabled = new
		visible = new

var key_array : Array[int] = [
	KEY_W, KEY_A, KEY_S, KEY_D
]
var next_key : int:
	set(new):
		next_key = new
		match new:
			KEY_W:
				key_label.text = 'W'
			KEY_A:
				key_label.text = 'A'
			KEY_S:
				key_label.text = 'S'
			KEY_D:
				key_label.text = 'D'


func _ready():
	next_key = key_array.pick_random()

func _input(event):
	if !enabled:return
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == next_key:
				next_key = key_array.pick_random()
				key_hit.emit()
				anim.play("key_hit")
			else:
				key_missed.emit()
				anim.play("key_missed")


func _process(delta):
	time_left -= delta
