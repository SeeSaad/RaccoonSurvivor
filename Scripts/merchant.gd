extends Node2D
var father: Node2D = null
var found_father : bool = false

func _ready():
	%AnimationPlayer.play("fade-in")
	if get_parent().name == "merchant_spawner":
		father = get_parent()
		found_father = true

func exit():
	%AnimationPlayer.play("fade-out")

func get_data():
	if father != null:
		father.get_not_owned()

func pistol(action : String, price : String):
	%pistol_label.text = action + " " + price

func sniper(action : String, price : String):
	%sniper_label.text = action + " " + price

func granade(action : String, price : String):
	%granade_label.text = action + " " + price

func life(action : String, price : String):
	%extra_life_label.text = action + " " + price

func dual(action : String, price : String):
	%dual_label.text = action + " " + price

func _on_pistol_button_button_down():
	if found_father:
		father.pistol_pressed()

func _on_sniper_button_button_down():
	if found_father:
		father.sniper_pressed()

func _on_rpg_button_button_down():
	if found_father:
		father.rpg_pressed()

func _on_granade_button_button_down():
	if found_father:
		father.granade_pressed()

func _on_suco_button_button_down():
	if found_father:
		father.suco_pressed()

func _on_dual_button_button_down():
	if found_father:
		father.dual_pressed()
