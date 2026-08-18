extends MicroGame

@onready var hand_open_png = preload("res://micro_games/garbage_sorting_game/HandOpen.png")
@onready var garbage_array : Array[Garbage] = [
	$Garbage/GarbageScene, $Garbage/GarbageScene2, $Garbage/GarbageScene3, $Garbage/GarbageScene4, $Garbage/GarbageScene5, $Garbage/GarbageScene6, $Garbage/GarbageScene7, $Garbage/GarbageScene8, $Garbage/GarbageScene9, $Garbage/GarbageScene10, $Garbage/GarbageScene11, $Garbage/GarbageScene12, $Garbage/GarbageScene13, $Garbage/GarbageScene14, $Garbage/GarbageScene15, $Garbage/GarbageScene16, $Garbage/GarbageScene17, $Garbage/GarbageScene18, $Garbage/GarbageScene19, $Garbage/GarbageScene20
]
@onready var garbage_bins : Array[GarbageEater] = [
	$GarbageBins/GarbageEater, $GarbageBins/GarbageEater2, $GarbageBins/GarbageEater3, $GarbageBins/GarbageEater4
]
@onready var spawn_reference := $SpawnReference
@onready var rng = RandomNumberGenerator.new()
@onready var win_screen := $EndScreenLayer/Win
@onready var lose_screen := $EndScreenLayer/Lose
@onready var timer_label := $CanvasLayer/Control/TimerLabel

@export var garbage_count : int = 10:
	set(new):
		garbage_count = new
		if new <= 0:
			Input.set_custom_mouse_cursor(null)
			print("your did it!!!1!")
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			win_screen.win()
			timer_label.stop()
			win.emit()

func _ready():
	arrange_garbage()
	connect_bins()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_custom_mouse_cursor(hand_open_png, 0, Vector2(32, 32))
	timer_label.start(game_duration)

func arrange_garbage():
	for i in garbage_count:
		rng.randomize()
		var j := rng.randi_range(0, len(garbage_array) - 1)
		var g := garbage_array[j]
		garbage_array.remove_at(j)
		var x_pos = rng.randf_range(-500, 500)
		var y_pos = rng.randf_range(100, 250) * (1 - 2 * randi_range(0, 1))
		g.global_position = spawn_reference.global_position + Vector2(x_pos, y_pos)

func connect_bins():
	for b in garbage_bins:
		b.connect("garbage_consumed", garbage_consumed)

func garbage_consumed():
	garbage_count -= 1


func _on_lose():
	lose_screen.lose()
	timer_label.stop()
	for b in garbage_bins:
		b.set_deferred("monitoring", false)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
