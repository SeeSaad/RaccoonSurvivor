extends CharacterBody2D

const turn_speed = 5
const aim_speed = 20
const mov_speed = 600

@onready var bullet = preload("res://Scenes/bullet.tscn")
#@onready var shield = preload("res://Scenes/bullet.tscn")
#@onready var gun = preload("res://Scenes/bullet.tscn")
#@onready var rpg = preload("")

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
	elif direction != Vector2.ZERO:
		%animation.play("walk")
		rotate_to_target(global_position + direction, delta, turn_speed)
	if Input.is_action_just_pressed("Shoot"):
		shoot()
		
func shoot():
	#call current gun method
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = %shooting_point.global_position
	new_bullet.global_rotation = %shooting_point.global_rotation
	%bullet_container.add_child(new_bullet)

func rotate_to_target(target, delta, speed):
	var direction = (target - global_position)
	var angle_to = transform.x.angle_to(direction)
	rotate(sign(angle_to) * min(delta * speed, abs(angle_to)))
