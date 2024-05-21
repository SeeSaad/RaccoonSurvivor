extends Node2D

var paused : bool = false

func _input(event):
	if event.is_pressed() && event.is_action("pause"):
		if !paused:
			pause()
		else:
			unpause()

func pause():
	paused = true
	get_tree().paused = true

func unpause():
	paused = false
	get_tree().paused = false
