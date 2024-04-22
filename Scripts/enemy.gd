extends CharacterBody2D

var health = 5.0

const turn_speed = 5
const mov_speed = 200
var target = null
var last_pos = null

#var knockback = Vector2.ZERO

func _physics_process(delta):
	if target != null:
		rotate_to_target(target.global_position, delta)
		velocity = (target.global_position - global_position).normalized() * mov_speed
	elif last_pos != null:
		velocity = (last_pos - global_position).normalized() * mov_speed
		if (last_pos - global_position).length() < 5:
			last_pos = null
	#velocity += knockback
	#if knockback.length() < 20:
		#knockback = Vector2.ZERO
	#elif knockback != Vector2.ZERO:
		#knockback -= 10
	#velocity += knockback
	move_and_slide()

func rotate_to_target(target, delta):
	var direction = (target - global_position)
	var angle_to = transform.x.angle_to(direction)
	rotate(sign(angle_to) * min(delta * turn_speed, abs(angle_to)))

func take_damage(damage):
	health -= damage
	#knockback = r_knockback
	if health <= 0:
		queue_free() # die!

func _on_area_2d_body_entered(body):
	if body.name == "Raccoon":
		target = body

func _on_area_2d_body_exited(body):
	if body == target:
		last_pos = target.global_position
		target = null
