extends Node2D

@export var area : Area2D
@export var animation_player : AnimationPlayer
@export var damage : float
@export var knockback : int

func _ready():
	animation_player.play("explode")

func explode():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(damage, (body.global_position - global_position).normalized(), knockback)
