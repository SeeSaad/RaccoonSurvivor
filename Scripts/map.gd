extends Node2D

const special_data = [[], [], [], [], []]

var spawners = []
var finished_spawning = []

enum data_label {spawn_num, spawn_time, spawn_interval, health, attack_speed, walk_speed, run_speed, speedup_speed}
var data = [3, 1.0, 1.5, 4.0, 0.7, 300, 600, 20]

var rodada : int = 1

func _ready():
	spawners.append(%enemy_spawner)
	set_data()
	start_all()

func initialize_all():
	var id : int = 0
	for i in spawners:
		i.set_id(id)
		finished_spawning.append(false)
		id += 1

func start_all():
	for i in spawners:
		i.start()

func set_data():
	for i in spawners:
		i.set_enemies_to_spawn(data[data_label.spawn_num])
		i.set_enemy_minimal_spawn_time(data[data_label.spawn_time])
		i.set_enemy_spawn_interval(data[data_label.spawn_interval])
		i.set_enemy_health(data[data_label.health])

func spawner_finished():
	# this function is called by the spawner and needs to:
	# if all spawners have finished:
	# 	start timer to change round
	pass
