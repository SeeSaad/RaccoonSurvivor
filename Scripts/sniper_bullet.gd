extends Area2D

const velocity : int = 2000
var damage : float = 1
const knockback : int = 800

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += delta * direction * velocity

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage, transform.x, knockback)
	else:
		queue_free()

func set_damage(num : float):
	damage = num
