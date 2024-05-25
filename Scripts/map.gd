extends Node2D

var UI

var spawners = []
var finished_spawning = []

enum L {spawn_num, spawn_time, spawn_interval, health, walk_speed, run_speed, speedup_speed}
var data = [3, 2.0, 1.5, 4.0, 300, 600, 20]

var rodada : int = 1

var round_timer = Timer.new()

var points : int = 0

@onready var round_count = preload("res://Scenes/round_count.tscn")

func _ready():
	spawners.append(%enemy_spawner)
	set_data()
	initialize_all()
	start_all()
	
	round_timer.autostart = false
	round_timer.one_shot = true
	round_timer.timeout.connect(next_round)
	add_child(round_timer)
	
	UI = get_node("UI")

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
		i.set_enemies_to_spawn(data[L.spawn_num])
		i.set_enemy_minimal_spawn_time(data[L.spawn_time])
		i.set_enemy_spawn_interval(data[L.spawn_interval])
		i.set_enemy_health(data[L.health])
		i.set_enemy_speed(data[L.walk_speed], data[L.run_speed], data[L.speedup_speed])

func spawner_finished(id : int):
	finished_spawning[id] = true
	
	for i in finished_spawning:
		if !i:
			return
	
	round_countdown()

func more_stats():
	data[L.spawn_num] += 1
	data[L.spawn_time] -= 0.05
	data[L.spawn_interval] -= 0.05
	data[L.health] += 0.5
	data[L.walk_speed] += 10
	data[L.run_speed] += 30
	data[L.speedup_speed] += 10
	set_data()

func next_round():
	UI.set_round(str(rodada))
	for i in finished_spawning:
		i = false
	start_all()

func round_countdown():
	rodada += 1
	round_timer.start(10)
	add_child(round_count.instantiate())
	more_stats()

func add_points():
	points += 100
	refresh_points() # adds points and refreshes ui

func refresh_points():
	if UI != null:
		UI.set_points(str(points))
