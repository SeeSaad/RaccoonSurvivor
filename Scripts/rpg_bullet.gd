extends Area2D

var parent

const velocity : int = 1000
var damage : float = 5
var projectile_damage : float = 2
const knockback : int = 500

@onready var explosion = preload("res://Scenes/armas/explosion.tscn")

func _ready():
	parent = get_parent()

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += delta * direction * velocity

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	call_deferred("_create_and_add_explosion")
	
	if body.has_method("take_damage"):
		body.take_damage(damage, transform.x, knockback)
	queue_free()

func _create_and_add_explosion():
	var new_explosion = explosion.instantiate()
	new_explosion.global_position = global_position
	new_explosion.damage = damage
	parent.add_child(new_explosion)

func set_damage(num : float):
	damage = num
