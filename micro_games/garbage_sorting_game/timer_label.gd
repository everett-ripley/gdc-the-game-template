extends Label

@onready var timer := $Timer

var seconds : float = 10.0:
	set(new):
		seconds = new
		if new <= 0:
			timer.stop()

func start(time:float):
	seconds = time
	text = str(int(ceil(time)))
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func stop():
	timer.stop()

func _on_timer_timeout():
	seconds -= 1
	text = str(int(ceil(seconds)))
