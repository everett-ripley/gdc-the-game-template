extends Control

@onready var confetti_particles := $ConfettiParticles
@onready var cr := $ColorRect
@onready var anim := $AnimationPlayer

func win():
	show()
	confetti_particles.emitting = true
	var t := create_tween()
	t.tween_property(cr, "modulate", Color(1,1,1,1), 0.2)
	await t.finished
	anim.play("label_anim")
