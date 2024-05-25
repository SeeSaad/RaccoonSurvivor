extends CanvasLayer

@export var kenzo : Sprite2D

func _ready():
	center_node()

func center_node():
	var viewport_size = kenzo.get_viewport_rect().size
	kenzo.position = viewport_size / 2  # Center the node/sprite

func _on_Viewport_resized():  # Recalculate on resize
	center_node()
