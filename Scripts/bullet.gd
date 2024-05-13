extends Area2D

const velocity = 1000
const damage = 1
const knockback = 200
var remaining_hits = 3

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += delta * direction * velocity

func _on_visible_on_screen_notifier_2d_screen_exited():
	if remaining_hits <= 0:
		queue_free()

func _on_body_entered(body): # parede (detecta tilemap)
	if body.has_method("take_damage"):
		body.take_damage(damage, transform.x, knockback)
		remaining_hits-=1
		if remaining_hits <= 0:
			queue_free()
