extends CharacterBody2D

@onready var navigation_agent : NavigationAgent2D = %NavigationAgent2D
var spawner : Marker2D = null

var health : float = 5.0

const turn_speed : int = 5
const enemy_attack_strengh : float = 1.0
const knockback_recovery : int = 10
var knockback_counter : int = 10

var default_speed : int = 400
var mov_speed : float = 400
var max_speed : int = 800
var speedup_speed : int = 20

var target = null
var current_target

var knockback = Vector2.ZERO

var died : bool = false
var attacking : bool = false
var in_attack_range : bool = false
var attack_timer = Timer.new()

func _ready():
	attack_timer.autostart = false
	attack_timer.one_shot = true
	attack_timer.timeout.connect(execute_attack)
	add_child(attack_timer)
	
	if get_parent().has_method("end"):
		spawner = get_parent()
	
	navigation_agent.target_position = target.global_position

func _physics_process(delta):
	handle_attack()
	
	handle_navigation()
	current_target = get_target()
	if current_target != null:
		rotate_to_target(current_target, delta)
		%movement_animation.play("walk")
	else:
		velocity = Vector2.ZERO
	
	speedup(delta)
	
	handle_knockback(delta)
	move_and_slide()

func speedup(delta):
	if mov_speed < max_speed:
		mov_speed += delta * speedup_speed

func get_target():
	if target != null:
		return target.global_position
	else:
		return null

func handle_navigation():
	var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
	velocity = direction * mov_speed

func handle_attack():
	if in_attack_range && not attacking:
		%attack_animation.play("attack")
		attacking = true
		attack_timer.start(0.5)

func handle_knockback(delta):
	const threshold : int = 20
	const knockback_decrement : float = 50
	
	if knockback_counter > 1 :
		knockback_counter -= delta
	if knockback_counter < 1 :
		knockback_counter = 1
		
	var knockback_value : float = knockback_decrement / knockback_counter
	
	if knockback.x > 0:
		if knockback.x < threshold:
			knockback.x = 0
		else:
			knockback.x -= knockback_value
	elif knockback.x < 0:
		if knockback.x > -threshold:
			knockback.x = 0
		else:
			knockback.x += knockback_value

	if knockback.y > 0:
		if knockback.y < threshold:
			knockback.y = 0
		else:
			knockback.y -= knockback_value
	elif knockback.y < 0:
		if knockback.y > -threshold:
			knockback.y = 0
		else:
			knockback.y += knockback_value

func rotate_to_target(target_position, delta):
	var direction = (target_position - global_position)
	var angle_to = transform.x.angle_to(direction)
	rotate(sign(angle_to) * min(delta * turn_speed, abs(angle_to)))

func take_damage(damage, direction, knockback_val):
	health -= damage
	knockback = direction * knockback_val
	mov_speed = default_speed
	knockback_counter = knockback_recovery # reset knockback recovery
	%flash_animation.play("shot")
	
	if health <= 0 and !died:
		died = true
		if spawner != null:
			spawner.enemy_killed()
		queue_free() # die!

func execute_attack():
	if in_attack_range && target != null:
		target.take_damage(enemy_attack_strengh)
	else:
		in_attack_range = false
	attacking = false

func set_target(body):
	target = body

func set_data(i_health : float, i_walk : int, i_run : int, i_speedup : int):
	default_speed = i_walk
	max_speed = i_run
	speedup_speed = i_speedup
	health = i_health

func _on_attack_area_body_entered(body):
	if body.name == "Raccoon":
		in_attack_range = true

func _on_attack_area_body_exited(body):
	if body.name == "Raccoon":
		in_attack_range = false

func _on_timer_timeout():
	if target != null:
		navigation_agent.target_position = target.global_position
