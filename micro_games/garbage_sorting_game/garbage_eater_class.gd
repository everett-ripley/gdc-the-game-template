class_name GarbageEater
extends Area2D

signal garbage_consumed

@export_enum("GARBAGE", "COMPOST", "RECYCLING", "PAPER") var garbage_type

@onready var sounds : Array[AudioStreamPlayer2D] = [
	$Throwaway1, $Throwaway2, $Throwaway3
]

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(area):
	if area is Garbage:
		if area.garbage_type == garbage_type:
			consume_the_trash(area)

func consume_the_trash(garbage:Garbage):
	print("yum")
	var s : AudioStreamPlayer2D = sounds.pick_random()
	s.pitch_scale = randf_range(0.9, 1.1)
	s.playing = true
	garbage_consumed.emit()
	garbage.throw_away(global_position)
