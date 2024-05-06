extends Area2D

const velocity = 1000
const damage = 0
const aoe_damage = 3.0
const knockback = 200

var enemies_in_aoe = []

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += delta * direction * velocity

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_aoe_area_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_in_aoe.append(body)

func _on_aoe_area_body_exited(body):
	if body.is_in_group("enemy") and body in enemies_in_aoe:
		enemies_in_aoe.erase(body)

func _on_body_entered(body): # parede (detecta tilemap)
	if body.is_in_group("enemy"):
		body.take_damage(damage, transform.x, knockback)
		for enemy in enemies_in_aoe:
			enemy.take_damage(aoe_damage, transform.x, knockback)
	queue_free()
