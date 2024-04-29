extends Node2D

@onready var bullet = preload("res://Scenes/pistol_bullet.tscn")

#var ammo = 30
#
#func got_ammo(qtd):
	#ammo += qtd
#
#func get_ammo():
	#return ammo

func shoot():
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = %shooting_point.global_position
	new_bullet.global_rotation = %shooting_point.global_rotation
	%bullet_container.add_child(new_bullet)
