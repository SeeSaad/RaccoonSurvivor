extends Node2D

@onready var bullet = preload("res://Scenes/pistol_bullet.tscn")
var timeout_timer = Timer.new()

const damage_upgrade = [0.9, 1.1, 1.3]
const trigger_upgrade = [1, 0.8, 0.6]
const magazine_upgrade = [10, 20, 25]
const reload_speed : float = 1.5

var upgrade_status : int = 0

var bullet_damage : float
var trigger_speed : float
var magazine : int
var bullet_count : int

var can_shoot : bool = true

func _ready():
	bullet_damage = damage_upgrade[0]
	trigger_speed = trigger_upgrade[0]
	magazine = magazine_upgrade[0]
	bullet_count = magazine
	
	timeout_timer.autostart = false
	timeout_timer.timeout.connect(ready_gun)
	add_child(timeout_timer)

func shoot():
	if can_shoot:
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = %shooting_point.global_position
		new_bullet.global_rotation = %shooting_point.global_rotation
		%bullet_container.add_child(new_bullet)

		bullet_count -= 1
		if bullet_count == 0:
			reload()
		else:
			timeout_timer.start(trigger_speed)
			can_shoot = false

func upgrade():
	upgrade_status += 1
	bullet_damage = damage_upgrade[0]
	trigger_speed = trigger_upgrade[0]
	magazine = magazine_upgrade[0]
	
func reload():
	can_shoot = false
	timeout_timer.start(reload_speed)

func ready_gun():
	if bullet_count == 0:
		bullet_count = magazine
	can_shoot = true

func get_ammo():
	return bullet_count
