@tool
class_name Garbage
extends Area2D


@export_enum("GARBAGE", "COMPOST", "RECYCLING", "PAPER") var garbage_type
@export var texture : CompressedTexture2D:
	set(new):
		if sprite != null:
			sprite.texture = new
			texture = new
		else:
			print("WARNING: No Sprite!")
@export var sprite : Sprite2D
@export var default_scale := Vector2(1.0,1.0):
	set(new):
		if sprite != null:
			sprite.scale = new
			default_scale = new

@onready var ref := $Ref
@onready var hand_open_png = preload("res://micro_games/garbage_sorting_game/HandOpen.png")
@onready var hand_closed_png = preload("res://micro_games/garbage_sorting_game/HandClosed.png")
@onready var glow_effect := $GlowEffect

const throw_away_anim_time : float = 0.4

enum grab_states {
	ungrabbed,
	grabbable,
	grabbed,
	NONE
}
var grab_state := grab_states.ungrabbed:
	set(new):
		grab_state = new
		match grab_state:
			grab_states.ungrabbed:
				sprite.z_index = 0
				unhighlight()
				glow_effect.show()
			grab_states.grabbable:
				highlight()
			grab_states.grabbed:
				sprite.z_index = 1
				jiggle()
				glow_effect.hide()
				Input.set_custom_mouse_cursor(hand_closed_png, 0, Vector2(32, 32))

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and grab_state == grab_states.grabbable:
			print("Move")
			grab_state = grab_states.grabbed
		elif !event.is_pressed() and grab_state == grab_states.grabbed:
			print("Stop")
			grab_state = grab_states.grabbable
			Input.set_custom_mouse_cursor(hand_open_png, 0, Vector2(32, 32))
			glow_effect.show()
	if event is InputEventMouseMotion:
		if grab_state == grab_states.grabbed:
			position = event.position


func highlight():
	sprite.scale = default_scale * 1.1

func unhighlight():
	sprite.scale = default_scale

func jiggle():
	var t := create_tween()
	t.tween_property(ref, "scale", Vector2(0.8, 1.2), 0.1)
	t.tween_property(ref, "scale", Vector2(1.2, 0.8), 0.1)
	t.tween_property(ref, "scale", Vector2.ONE, 0.1)

func _on_mouse_entered():
	print("mouse entered")
	grab_state = grab_states.grabbable
	


func _on_mouse_exited():
	print("mouse exited")
	if grab_state == grab_states.grabbable:
		grab_state = grab_states.ungrabbed

func throw_away(target_position:Vector2):
	glow_effect.hide()
	Input.set_custom_mouse_cursor(hand_open_png, 0, Vector2(32, 32))
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	disconnect("mouse_entered", _on_mouse_entered)
	grab_state = grab_states.NONE
	var t := create_tween()
	t.tween_property(sprite, "modulate", Color(0,0,0,0), throw_away_anim_time)
	t.parallel().tween_property(sprite, "rotation", PI, throw_away_anim_time)
	t.parallel().tween_property(sprite, "scale", Vector2(0.1, 0.1), throw_away_anim_time)
	t.parallel().tween_property(self, "global_position", target_position, throw_away_anim_time)
