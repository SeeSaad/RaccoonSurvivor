extends Node2D

@onready var pause_controller = get_parent().get_node("pause_controller")

@onready var merchant = preload("res://Scenes/merchant/merchant.tscn")
var new_merchant
var merchant_in_screen : bool = false

func _input(event):
	if merchant_in_screen and event.is_action_pressed("pause"):
		merchant_in_screen = false
		new_merchant.exit()

func _on_area_2d_body_entered(body):
	if body.name == "Raccoon":
		new_merchant = merchant.instantiate()
		add_child(new_merchant)
		pause_controller.pause()
		merchant_in_screen = true

func _on_area_2d_body_exited(body):
	if body.name == "Raccoon" and merchant_in_screen:
		merchant_in_screen = false
		new_merchant.exit()

func get_not_owned():
	pass #get not owned weapons from player
