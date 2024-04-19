extends Area2D

const velocity = 200
const damage = 0.5

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += delta * direction * velocity

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage()
	else:
		print("bullet encountered unknown item")
