extends Area2D

const velocity = 1000
const damage = 0.5
const knockback = 200

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += delta * direction * velocity

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body): # parede (detecta tilemap)
	if body.has_method("take_damage"):
		body.take_damage(damage, transform.x, knockback)
	queue_free()
