extends Control

@export var lose_messages : Array[String]
@onready var cr := $ColorRect
@onready var label := $RichTextLabel
@onready var lose_sound := $LoseSound

func lose():
	show()
	lose_sound.play()
	var t := create_tween()
	t.tween_property(cr, "modulate", Color(1,1,1,1), 0.2)
	label.append_text(lose_messages.pick_random())
	t.tween_property(label, "modulate", Color(1,1,1,1), 0.5)
