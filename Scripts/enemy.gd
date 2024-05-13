extends CharacterBody2D

var health : float = 5.0

const turn_speed : int = 5
# const knockback_recovery = 10
const enemy_attack_strengh : float = 1.0

var default_speed : int = 400
var mov_speed : float = 400
var max_speed : int = 800
var speedup_speed : int = 20

var target = null
var last_pos = null
var current_target = null

var knockback = Vector2.ZERO

var attacking = false
var in_attack_range = false
var attack_timer = Timer.new()

func _ready():
	attack_timer.autostart = false
	attack_timer.timeout.connect(execute_attack)
	add_child(attack_timer)

func _physics_process(delta):
	handle_attack()
	current_target = get_target()
	if current_target != null:
		rotate_to_target(current_target, delta)
		velocity = (current_target - global_position).normalized() * mov_speed + knockback
		%movement_animation.play("walk")
	else:
		velocity = Vector2.ZERO
	
	speedup(delta)
	
	handle_knockback()
	move_and_slide()

func speedup(delta):
	if mov_speed < max_speed:
		mov_speed += delta * speedup_speed

func get_target():
	if target != null:
		return target.global_position
	elif last_pos != null:
		if (last_pos - global_position).length() < 15:
			last_pos = null
			return null
		else:
			return last_pos

func handle_attack():
	if in_attack_range && not attacking:
		%attack_animation.play("attack")
		attacking = true
		attack_timer.start(0.5)

func handle_knockback():
	const threshold = 20
	const knockback_decrement = 10
	
	if knockback.x > 0:
		if knockback.x < threshold:
			knockback.x = 0
		else:
			knockback.x -= knockback_decrement
	elif knockback.x < 0:
		if knockback.x > -threshold:
			knockback.x = 0
		else:
			knockback.x += knockback_decrement

	if knockback.y > 0:
		if knockback.y < threshold:
			knockback.y = 0
		else:
			knockback.y -= knockback_decrement
	elif knockback.y < 0:
		if knockback.y > -threshold:
			knockback.y = 0
		else:
			knockback.y += knockback_decrement

func rotate_to_target(target_position, delta):
	var direction = (target_position - global_position)
	var angle_to = transform.x.angle_to(direction)
	rotate(sign(angle_to) * min(delta * turn_speed, abs(angle_to)))

func take_damage(damage, direction, knockback_val):
	health -= damage
	knockback = direction * knockback_val
	mov_speed = default_speed
	%flash_animation.play("shot")
	if health <= 0:
		queue_free() # die!

func execute_attack():
	if in_attack_range && target != null:
		target.take_damage(enemy_attack_strengh)
	else:
		in_attack_range = false
	attacking = false

func set_target(body):
	target = body

func _on_attack_area_body_entered(body):
	if body.name == "Raccoon":
		in_attack_range = true

func _on_attack_area_body_exited(body):
	if body.name == "Raccoon":
		in_attack_range = false
