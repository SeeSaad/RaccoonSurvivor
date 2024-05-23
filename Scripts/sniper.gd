extends Node2D

var UI : CanvasLayer = null
var bullet_container

@onready var bullet = preload("res://Scenes/armas/sniper_bullet.tscn")
var timeout_timer = Timer.new()

const upgrade_price = [500, 1000, 3000]

const damage_upgrade = [1, 2, 3]
const trigger_upgrade = [1, 0.7, 0.5]
const magazine_upgrade = [5, 7, 10]
const reload_speed : float = 5.5

var upgrade_status : int = 0
var max_upgrade : int = 2

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
	
	refresh_bullet_UI()

func _physics_process(delta):
	pass

func shoot():
	if can_shoot:
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = %shooting_point.global_position
		new_bullet.global_rotation = %shooting_point.global_rotation
		new_bullet.set_damage(bullet_damage)
		bullet_container.add_child(new_bullet)

		bullet_count -= 1
		refresh_bullet_UI()
		if bullet_count == 0:
			reload()
		else:
			timeout_timer.start(trigger_speed)
			can_shoot = false

func upgrade():
	if (upgrade_status < max_upgrade):
		upgrade_status += 1
		bullet_damage = damage_upgrade[upgrade_status]
		trigger_speed = trigger_upgrade[upgrade_status]
		magazine = magazine_upgrade[upgrade_status]
	
func reload():
	can_shoot = false
	bullet_count = magazine
	timeout_timer.start(reload_speed)

func ready_gun():
	refresh_bullet_UI()
	can_shoot = true

func get_ammo():
	return bullet_count

func set_bullet_container(node):
	bullet_container = node

func weapon_data():
	if upgrade_status >= 2:
		return [2, null]
	else:
		return [upgrade_status, upgrade_price[upgrade_status]]

func inicialize_timer_UI():
	pass

func refresh_bullet_UI():
	if UI != null:
		UI.set_sniper_ammo(str(bullet_count))

func set_UI(reference):
	UI = reference
