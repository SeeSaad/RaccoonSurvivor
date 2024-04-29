extends CharacterBody2D

var health : float = 5.0

const turn_speed : int = 5
const aim_speed : int = 20
const mov_speed : int = 600

var aiming : bool = false

var duas_armas : bool = true

var current_weapon_r = null
var current_weapon_l = null

#@onready var shield = preload("res://Scenes/bullet.tscn")
#@onready var pistol = preload("res://Scenes/pistol.tscn")
#@onready var rpg = preload("")
func _ready():
	pass

func _physics_process(delta):
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * mov_speed
	if direction == Vector2.ZERO:
		%animation.play("idle")
	else:
		%animation.play("walk")
		move_and_slide()

	if Input.is_action_pressed("Aim"):
		rotate_to_target(get_global_mouse_position(), delta, aim_speed)
		rotate_gun(global_position.distance_to(get_global_mouse_position()), delta, aim_speed)
	elif direction != Vector2.ZERO:
		rotate_to_target(global_position + direction, delta, turn_speed)
	if Input.is_action_just_pressed("Shoot"):
		shoot()

func _input(event):
	if event.is_action_pressed("pistol"):
		hide_curr_weapon()
		current_weapon_r = %r_pistol
		current_weapon_l = %l_pistol
		current_weapon_r.visible = true
		current_weapon_l.visible = true
	elif event.is_action_pressed("sniper"):
		hide_curr_weapon()
		current_weapon_r = null
		current_weapon_l = null

func hide_curr_weapon():
	if current_weapon_r != null:
		current_weapon_r.visible = false
	if current_weapon_l != null:
		current_weapon_l.visible = false

func shoot():
	if current_weapon_r != null:
		current_weapon_r.shoot()
		current_weapon_l.shoot()

func rotate_to_target(target, delta, speed):
	var direction = (target - global_position)
	var angle_to = transform.x.angle_to(direction)
	rotate(sign(angle_to) * min(delta * speed, abs(angle_to)))

func rotate_gun(target, delta, speed):
	var angle_to = atan2(target, %r_arm.position.y)
	var corrected_angle = angle_to - (PI/2)
	%r_arm.rotation = corrected_angle
	if duas_armas:
		corrected_angle = (PI/2) - angle_to
		%l_arm.rotation = corrected_angle

func take_damage(damage):
	#if shield activated (do nothing)
	health -= damage
	print(health)
	if health <= 0:
		queue_free()
		print("GAME OVER")
