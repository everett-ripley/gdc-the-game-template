extends Control

@onready var pb := $TextureProgressBar
@onready var label := $TimeLabel

var max_time : float = 10.0

func set_time_left(time:float):
	pb.value = time / max_time
	label.text = str(int(ceil(time)))
