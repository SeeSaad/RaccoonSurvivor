extends Node2D

@onready var merchant = preload("res://Scenes/merchant.tscn")
var new_merchant

func _on_area_2d_body_entered(body):
	if body.name == "Raccoon":
		new_merchant = merchant.instantiate()
		add_child(new_merchant)

func _on_area_2d_body_exited(body):
	if body.name == "Raccoon":
		new_merchant.exit()

func get_not_owned():
	pass #get not owned weapons from player
