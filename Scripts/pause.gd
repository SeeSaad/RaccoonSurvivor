extends Control

@onready var main_menu = preload("res://Scenes/main_menu.tscn").instantiate()

func _on_button_button_down():
	get_parent().unpause()
	get_tree().root.add_child(main_menu)
	get_tree().root.get_node("map").queue_free()
