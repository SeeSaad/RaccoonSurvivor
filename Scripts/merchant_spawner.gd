extends Node2D

@onready var pause_controller = get_parent().get_node("pause_controller")

@onready var merchant = preload("res://Scenes/merchant/merchant.tscn")

var raccoon : CharacterBody2D = null

var new_merchant
var merchant_in_screen : bool = false

var map : Node2D = null
var found_map : bool = false

var weapons_maxed = [false, false, false]
var weapons_owned = [false, false, false]
var dual_owned = false

var pistol_data
var sniper_data
var rpg_data

func _ready():
	if get_parent().name == "map":
		map = get_parent()
		found_map = true
	else:
		print("mapa nao encontrado")

func _input(event):
	if merchant_in_screen and event.is_action_pressed("pause"):
		raccoon = null
		merchant_in_screen = false
		new_merchant.exit()

func _on_area_2d_body_entered(body):
	if body.name == "Raccoon":
		raccoon = body
		
		new_merchant = merchant.instantiate()
		get_not_owned(body)
		set_labels()
		add_child(new_merchant)
		pause_controller.pause()
		merchant_in_screen = true

func _on_area_2d_body_exited(body):
	if body.name == "Raccoon" and merchant_in_screen:
		raccoon = null
		merchant_in_screen = false
		new_merchant.exit()

func get_not_owned(body):
	pistol_data = body.get_weapon_data(0)
	sniper_data = body.get_weapon_data(1)
	
	weapons_owned[0] = body.weapons_owned[0]
	weapons_owned[1] = body.weapons_owned[1]
	weapons_owned[2] = body.weapons_owned[2]
	
	if pistol_data[0] == 2:
		weapons_maxed[0] = true
	
	if sniper_data[0] == 2:
		weapons_maxed[1] = true

func set_labels():
	if !weapons_owned[0]: # pistola
		print("pistola faltando, erro")
	elif weapons_maxed[0]:
		new_merchant.pistol("MAX", "")
	else:
		new_merchant.pistol("UPGRADE", str(pistol_data[1]))
	
	if !weapons_owned[1]: # sniper
		new_merchant.sniper("COMPRAR", "500")
	elif weapons_maxed[1]:
		new_merchant.sniper("MAX", "")
	else:
		new_merchant.sniper("UPGRADE", str(sniper_data[1]))

func transaction(num : int):
	if found_map and num > -1:
		if map.points > num:
			map.points -= num
			map.refresh_points()
			return true
		else:
			return false
	else:
		print("erro de transacao")
		return false

func pistol_pressed():
	if !weapons_owned[0] or weapons_maxed[0]:
		print("transacao impossivel")
		return
	if raccoon != null:
		if transaction(pistol_data[1]):
			raccoon.upgrade(0)
			get_not_owned(raccoon)
			set_labels()

func sniper_pressed():
	if weapons_maxed[1] or raccoon == null:
		print("transacao impossivel")
		return
	
	if !weapons_owned[1] and transaction(500):
		raccoon.weapons_owned[1] = true
		get_not_owned(raccoon)
		set_labels()
	elif weapons_owned[1] and transaction(sniper_data[1]):
		raccoon.upgrade(1)
		get_not_owned(raccoon)
		set_labels()

func rpg_pressed():
	pass

func granade_pressed():
	pass

func suco_pressed():
	pass

func dual_pressed():
	pass
