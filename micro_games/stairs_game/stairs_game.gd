extends MicroGame

@onready var climb_path := $ClimbPath
@onready var sprite := $ClimbPath/PathFollow2D/Ref/Sprite2D
@onready var ref := $ClimbPath/PathFollow2D/Ref
@onready var death_sprite := $DeathSprite
@onready var death_anim := $ShaderOverlay/DeathAnim
@onready var hud := $HUD

@export var step_progress : Array[float]
@export var win_texture : CompressedTexture2D

var step : int = 0:
	set(new):
		step = clamp(new, 0, 10)
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
			win.emit()


func _on_hud_key_hit():
	if step < 10:
		step += 1


func _on_lose():
	climb_path.enabled = false
	hud.enabled = false
	death_sprite.show()
	death_anim.play("death")
