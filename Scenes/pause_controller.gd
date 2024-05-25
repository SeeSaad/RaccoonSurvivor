extends Node2D

@onready var pause_screen = preload("res://Scenes/UI/pause.tscn")
var new_pause

var paused : bool = false
var merchant_paused : bool = false

func _input(event):
	if event.is_pressed() && event.is_action("pause"):
		if !paused and !merchant_paused:
			pause()
		elif paused:
			unpause()

func pause():
	paused = true
	add_child(pause_screen.instantiate())
	get_tree().paused = true

func unpause():
	paused = false
	get_node("pause").queue_free()
	get_tree().paused = false

func merchant_pause():
	merchant_paused = true
	get_tree().paused = true

func merchant_unpause():
	merchant_paused = false
	get_tree().paused = false
