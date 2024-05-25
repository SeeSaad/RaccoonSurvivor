extends Node2D

func _ready():
	center_node()

func center_node():
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2  # Center the node/sprite

func _on_Viewport_resized():  # Recalculate on resize
	center_node()  
