extends MicroGame


const minute_inc : int = 5
const button_unpressed_y : int = -24
const button_pressed_y : int = -16

@onready var hour_button := $GameLayer/AlarmClockSprite/HourButton
@onready var minute_button := $GameLayer/AlarmClockSprite/MinuteButton
@onready var hour_label := $GameLayer/Control/HBoxContainer/HourLabel
@onready var minute_label := $GameLayer/Control/HBoxContainer/MinuteLabel
@onready var target_hour_label := $GameLayer/Control/HBoxContainer2/HourLabel
@onready var target_minute_label := $GameLayer/Control/HBoxContainer2/MinuteLabel

var hour_target : int
var minute_target : int

var hour : int = 0:
	set(new):
		if new > 23: new = 0
		hour = new
		hour_label.text = str(hour)
var minute : int = 0:
	set(new):
		if new >= 60:
			new = 0
		minute = new
		var min_str : String = str(minute)
		if minute < 10:
			min_str = "0" + min_str
		minute_label.text = min_str
		

func _ready():
	hour_target = randi_range(1, 23)
	minute_target = randi_range(1, 11) * 5
	target_hour_label.text = str(hour_target)
	var min_str : String = str(minute_target)
	if minute_target < 10:
		min_str = "0" + min_str
	target_minute_label.text = min_str


func _input(event):
	if event is InputEventKey:
		hour_button.position.y = button_unpressed_y
		minute_button.position.y = button_unpressed_y
		if event.pressed:
			match event.keycode:
				KEY_A:
					hour += 1
					hour_button.position.y = button_pressed_y
				KEY_D:
					minute += minute_inc
					minute_button.position.y = button_pressed_y
				KEY_W:
					if check_equality():
						win.emit()
						print("yay")


func check_equality()->bool:
	return hour == hour_target and minute == minute_target
