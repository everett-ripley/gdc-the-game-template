extends Node2D

@export var shake_radius : float = 10.0

var default_pos : Vector2

func _ready():
	default_pos = position
	

func _process(delta):
	var rad : float = randf_range(0, shake_radius)
	var ang : float = randf_range(0, TAU)
	var displace : Vector2 = Vector2(1, 0).rotated(ang) * rad
	position = default_pos + displace
