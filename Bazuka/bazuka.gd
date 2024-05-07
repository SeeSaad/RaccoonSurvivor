extends Node2D

@onready var bullet = preload("res://Bazuka/bazuka_bullet.tscn")

var rate_of_fire: int = 3000 # milliseconds
var last_shoot: int = -3000

#var ammo = 30
#
#func got_ammo(qtd):
	#ammo += qtd
#
#func get_ammo():
	#return ammo

func shoot():
	# rate of fire (1 bullet p/ 3 seconds)
	if Time.get_ticks_msec() >= last_shoot + rate_of_fire:
		last_shoot = Time.get_ticks_msec()
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = %shooting_point.global_position
		new_bullet.global_rotation = %shooting_point.global_rotation
		%bullet_container.add_child(new_bullet)
