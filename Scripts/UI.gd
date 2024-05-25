extends CanvasLayer

func set_pistol_ammo(count : String):
	%pistol_count.text = count
func set_pistol_pb(min_timer: float, max_timer: float):
	%pistol_progress.min_value = min_timer
	%pistol_progress.max_value = max_timer
func pistol_pb(timer: float):
	%pistol_progress.value = timer

func set_sniper_ammo(count : String):
	%sniper_count.text = count
func set_sniper_pb(min_timer: float, max_timer: float):
	%sniper_progress.min_value = min_timer
	%sniper_progress.max_value = max_timer
func sniper_pb(timer: float):
	%sniper_progress.value = timer

func set_rpg_ammo(count : String):
	%rpg_count.text = count
func set_rpg_pb(min_timer: float, max_timer: float):
	%rpg_progress.min_value = min_timer
	%rpg_progress.max_value = max_timer
func rpg_pb(timer: float):
	%rpg_progress.value = timer

func sniper_visible():
	%sniper_container.visible = true
func rpg_visible():
	%rpg_container.visible = true

func set_granade(count : String):
	%granade_count.text = count

func set_health(count : String):
	%health_count.text = count

func set_stamina(count : String):
	%stamina_count.text = count

func set_round(count : String):
	%round_count.text = count

func set_points(count : String):
	%points_count.text = count
