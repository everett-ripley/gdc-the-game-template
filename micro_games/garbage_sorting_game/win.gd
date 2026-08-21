extends Control

@onready var confetti_particles := $ConfettiParticles
@onready var cr := $ColorRect
@onready var anim := $AnimationPlayer
@onready var confetti_sound := $Confetti
@onready var jingle := $Cornywin1

func win():
	show()
	confetti_particles.emitting = true
	confetti_sound.play()
	var t := create_tween()
	t.tween_property(cr, "modulate", Color(1,1,1,1), 0.2)
	await t.finished
	await get_tree().create_timer(0.3).timeout
	anim.play("label_anim")
	jingle.play()
