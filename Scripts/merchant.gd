extends Node2D

func _ready():
	%AnimationPlayer.play("fade-in")

func exit():
	%AnimationPlayer.play("fade-out")
