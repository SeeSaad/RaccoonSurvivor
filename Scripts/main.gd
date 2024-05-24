extends Node

var main_menu = preload("res://Scenes/main_menu.tscn")
var call_menu : bool = false

func _input(event):
	if !call_menu and (event.is_action_pressed("dash") or event.is_action_pressed("pause")):
		call_menu = true
		get_tree().root.add_child(main_menu.instantiate())
		queue_free()
		
func _on_video_player_finished():
	if !call_menu:
		call_menu = true
		get_tree().root.add_child(main_menu.instantiate())
		queue_free()
