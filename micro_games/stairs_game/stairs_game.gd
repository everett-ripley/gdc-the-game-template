extends MicroGame

@onready var climb_path := $ClimbPath
@onready var sprite := $ClimbPath/PathFollow2D/Ref/Sprite2D
@onready var ref := $ClimbPath/PathFollow2D/Ref
@onready var death_sprite := $DeathSprite
@onready var death_anim := $ShaderOverlay/DeathAnim
@onready var hud := $HUD
@onready var step_sound := $StepSound
@onready var error_sound := $ErrorSound
@onready var death_chord := $DeathChord
@onready var win_anim := $WinScreen/WinAnim
@onready var win_screen := $WinScreen

@export var pitch_start : float = 1.0
@export var pitch_end : float = 1.5

@export var step_progress : Array[float]
@export var win_texture : CompressedTexture2D

var step : int = 0:
	set(new):
		var pitch = pitch_start + (pitch_end - pitch_start) * (float(step) / 10)
		step = clamp(new, 0, 10)
		step_sound.pitch_scale = pitch
		step_sound.play()
		var t := create_tween()
		t.tween_property(climb_path, "progress_ratio", step_progress[step], 0.1)
		t.parallel().tween_property(ref, "scale", Vector2(0.6, 1.5), 0.1)
		t.parallel().tween_property(sprite, "position", Vector2(0.0, -50.0), 0.1)
		t.tween_property(ref, "scale", Vector2.ONE, 0.1)
		t.parallel().tween_property(sprite, "position", Vector2.ZERO, 0.1)
		sprite.flip_h = !sprite.flip_h
		if step == 10:
			sprite.texture = win_texture
			hud.enabled = false
			win_screen.show()
			win_anim.play("win_anim")
			win.emit()


func _ready():
	hud.time_left = game_duration


func _on_hud_key_hit():
	if step < 10:
		step += 1


func _on_lose():
	climb_path.enabled = false
	hud.enabled = false
	death_chord.play()
	death_sprite.show()
	death_anim.play("death")


func _on_hud_key_missed():
	error_sound.play()
