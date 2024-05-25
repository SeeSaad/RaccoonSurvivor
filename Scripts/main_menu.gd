extends Node

var game
var iniciar_pressed : bool = false

func _ready():
	game = load("res://Scenes/tilemap.tscn")

func _on_iniciar_pressed():
	print("iniciarrrrr")
	if !iniciar_pressed:
		iniciar_pressed = true
		get_tree().root.add_child(game.instantiate())
		queue_free()

func _on_sair_pressed():
	print("sairrrrrr")
	get_tree().quit()
