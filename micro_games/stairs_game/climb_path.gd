@tool
extends Path2D

@export var scale_near : float = 1.0
@export var scale_far : float = 0.6

@onready var pf := $PathFollow2D
@onready var sprite := $PathFollow2D/Ref/Sprite2D

@export var progress_ratio : float = 0.0:
	set(new):
		progress_ratio = clamp(new, 0.0, 1.0)
		pf.progress_ratio = progress_ratio
		var s : float = scale_far * progress_ratio + scale_near * (1.0 - progress_ratio)
		sprite.scale = Vector2.ONE * s
