extends CharacterBody2D

var found_UI : bool = false
var UI
var found_map : bool = false
var map

var all_weapons = []

var dash_timer = Timer.new()
var dash_recovery_timer = Timer.new()

var weapons_owned = [true, false, false]
enum weapon_names {pistol, sniper, rpg}

var health : float = 5.0

const turn_speed : int = 5
const aim_speed : int = 20
const mov_speed : int = 600
const dash_speed : int = 2000

var dead : bool = false

var aiming : bool = false
var can_dash : bool = true
var dashing : bool = false
var dual_wield : bool = true

var current_weapon_r = null
var current_weapon_l = null

var direction : Vector2 = Vector2.ZERO

func _ready():
	dash_timer.autostart = false
	dash_timer.timeout.connect(end_dash)
	add_child(dash_timer)
	
	dash_recovery_timer.autostart = false
	dash_recovery_timer.timeout.connect(end_dash_recovery)
	add_child(dash_recovery_timer)
	
	map = get_parent().get_parent()
	UI = map.get_node("UI")
	
	found_map = map.name == "map"
	found_UI = UI != null
	refresh_ui()
	inicialize_weapons()

func _physics_process(delta):
	if dashing:
		velocity = dash_speed * direction
	else:
		direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * mov_speed
	
	if direction == Vector2.ZERO:
		%animation.play("idle")
	else:
		%animation.play("walk")
		move_and_slide()

	if aiming:
		rotate_to_target(get_global_mouse_position(), delta, aim_speed)
		rotate_gun(global_position.distance_to(get_global_mouse_position()))
	elif direction != Vector2.ZERO:
		rotate_to_target(global_position + direction, delta, turn_speed)

func _input(event):
	if !dead and event.is_pressed():
		if event.is_action("pistol"):
			equip_weapon(%r_pistol, %l_pistol)
		elif event.is_action("sniper") and weapons_owned[weapon_names.sniper]:
			equip_weapon(%l_sniper, %r_sniper)
		elif event.is_action("shoot"):
			shoot()
		elif event.is_action("aim"):
			aiming = true
		elif event.is_action("dash") and can_dash:
			start_dash()
		elif event.is_action("reload"):
			reload_weapon()
	else:
		if event.is_action("aim"):
			aiming = false

func inicialize_weapons():
	all_weapons.append(%l_pistol)
	all_weapons.append(%r_pistol)
	all_weapons.append(%l_sniper)
	all_weapons.append(%r_sniper)
	
	for i in all_weapons:
		i.set_bullet_container(map)
		
	if found_UI:
		print("found")
		for i in all_weapons:
			i.set_UI(UI)
	else:
		print("not_found")


func hide_curr_weapon():
	if current_weapon_r != null:
		current_weapon_r.visible = false
		current_weapon_r = null
	if current_weapon_l != null:
		current_weapon_l.visible = false
		current_weapon_l = null

func equip_weapon(r_gun, l_gun):
	hide_curr_weapon()
	current_weapon_r = r_gun
	current_weapon_r.visible = true
	if dual_wield:
		current_weapon_l = l_gun
		current_weapon_l.visible = true

func reload_weapon():
	if current_weapon_r != null:
		current_weapon_r.reload()
	if current_weapon_l != null:
		current_weapon_l.reload()

func shoot():
	if current_weapon_r != null:
		current_weapon_r.shoot()
	if current_weapon_l != null:
		current_weapon_l.shoot()

func start_dash():
	can_dash = false
	dashing = true
	dash_timer.start(0.2)
	dash_recovery_timer.start(0.7)
	refresh_dash_ui()

func end_dash():
	dashing = false

func end_dash_recovery():
	can_dash = true
	refresh_dash_ui()

func rotate_to_target(target, delta, speed):
	var aim_direction = (target - global_position)
	var angle_to = transform.x.angle_to(aim_direction)
	rotate(sign(angle_to) * min(delta * speed, abs(angle_to)))

func rotate_gun(target):
	var angle_to = atan2(target, %r_arm.position.y)
	var corrected_angle = angle_to - (PI/2)
	%r_arm.rotation = corrected_angle
	if dual_wield:
		corrected_angle = (PI/2) - angle_to
		%l_arm.rotation = corrected_angle

func take_damage(damage):
	if !dead:
		health -= damage
		refresh_health_ui()
		if health <= 0:
			dead = true
			%animation.stop()
			$die.play("die")
			print("GAME OVER")

func refresh_ui():
	refresh_health_ui()
	refresh_dash_ui()

func refresh_health_ui():
	if found_UI:
		UI.set_health(str(health))

func refresh_dash_ui():
	if found_UI:
		if can_dash:
			UI.set_stamina("11")
		else:
			UI.set_stamina("00")

func get_weapon_data(weapon : int):
	if weapon == 0:
		if !weapons_owned[0]:
			return [null, null]
		return %l_pistol.weapon_data()
	elif weapon == 1:
		if !weapons_owned[1]:
			return [null, null]
		return %l_sniper.weapon_data()
	elif weapon == 2:
		if !weapons_owned[2]:
			return [null, null]
		return null

func upgrade(num : int):
	if num == 0:
		%l_pistol.upgrade()
		%r_pistol.upgrade()
	if num == 1:
		%l_sniper.upgrade()
		%r_sniper.upgrade()
