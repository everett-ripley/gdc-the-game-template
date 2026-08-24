extends Node2D

@onready var nodes : Array[Node2D] = [$Node2D, $Node2D2, $Node2D3, $Node2D4, $Node2D5]

@onready var A : PackedScene = preload("res://micro_games/memory_game/SymbolA.tscn")
@onready var B : PackedScene = preload("res://micro_games/memory_game/SymbolB.tscn")
@onready var C : PackedScene = preload("res://micro_games/memory_game/SymbolC.tscn")
@onready var D : PackedScene = preload("res://micro_games/memory_game/SymbolD.tscn")

func display_pattern(pattern:String):
	if len(pattern) != 5:return
	var i : int = 0
	for c in pattern:
		var sym
		match c:
			"A":
				sym = A.instantiate()
			"B":
				sym = B.instantiate()
			"C":
				sym = C.instantiate()
			"D":
				sym = D.instantiate()
		nodes[i].add_child(sym)
		i += 1
