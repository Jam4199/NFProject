extends Node
class_name StatManager



#manages stats, buffs , debuffs and passive effects

@export var base_max_health : float = 100
@export var base_attack : float = 20
@export var base_defense : float = 10
@export var evasion : float = 10
@export var base_attack_speed : float = 1

@export_group("Element Ressistance")
@export var base_fire_res : float = 1
@export var base_cold_res : float = 1
@export var base_elec_res : float = 1

var max_health : float : get = get_max_health
var attack : float : get = get_attack
var defense : float : get = get_defense
var attack_speed : float : get = get_attack_speed
var fire_res : float : get = get_fire_res
var cold_res : float : get = get_cold_res
var elec_res : float : get = get_elec_res

var current_health : float : set = set_health
var alive : bool = true 

var unit : Unit

signal get_stat_adds(stat : String, adds : Array)
signal get_stat_mults(stat : String, mults : Array)
signal call_passives(passive_list : Array)
signal unit_died
signal damage_taken

func get_attack():
	var final_stat : float = base_attack
	final_stat = mod_stat("attack", final_stat)
	return final_stat

func get_defense():
	var final_stat : float = base_defense
	final_stat = mod_stat("defense", final_stat)
	return final_stat

func get_max_health():
	var final_stat : float = base_max_health
	final_stat = mod_stat("max_health", final_stat)
	return final_stat

func get_attack_speed():
	var final_stat : float = base_attack_speed
	final_stat = mod_stat("attack_speed", final_stat)
	return final_stat

func get_fire_res():
	var final_stat : float = base_fire_res
	final_stat = mod_stat("fire_res", final_stat)
	return final_stat

func get_cold_res():
	var final_stat : float = base_cold_res
	final_stat = mod_stat("cold_res", final_stat)
	return final_stat

func get_elec_res():
	var final_stat : float = elec_res
	final_stat = mod_stat("elec_res", final_stat)
	return final_stat

func speed_mod_check(speed_mods : Array):
	emit_signal("get_stat_mults", "move_speed", speed_mods)

func mod_stat(stat : String, value : float) -> float:

	var final_value : float = value
	var stat_adds : Array = []
	var passive_list : Array = get_passives()
	emit_signal("get_stat_adds",stat,stat_adds)
	for passive in passive_list:
		if passive.has_method("get_stat_adds"):
			passive.get_stat_adds(stat,stat_adds)
	for adds in stat_adds:
		final_value += adds
	
	var stat_mults : Array = []
	emit_signal("get_stat_mults",stat,stat_mults)
	for passive in passive_list:
		if passive.has_method("get_stat_mults"):
			passive.get_stat_adds(stat,stat_mults)
	for mult in stat_mults:
		final_value *= mult

	return final_value

func get_passives() -> Array: #write something to prevent dupe passives from different sources
	var passive_list : Array = []
	emit_signal("call_passives",passive_list)
	return passive_list

func check_locked():
	#get something to check for disables
	return false

func connect_mods(mod_source : Node):
	var connect_list : Array = ["get_stat_adds","get_stat_mults"]
	for item in connect_list:
		if mod_source.has_method(item):
			connect(item, Callable(mod_source,item))
	

func recieve_damage(damage : Damage):
	var damage_value : float = damage.damage_value
	
	# defense
	damage_value -= (damage_value * ((get_defense() * ((100 - damage.penetration )/ 100))/ (get_defense() + 10)))
	emit_signal("damage_taken", damage_value)
	#wip elemental ressistance
	#wip evasion use x = y / (y+50), evasion lowers max damage, but pressure can build up and push it back up. non pressure evasion is still counted as min damage. tracking counters evasion
	#wip evasion pressure use x = pressure/pressure+evasion
	print(str(damage_value))
	set_health(current_health - damage_value)
	print(str(current_health))

func set_health(new_value : float):
	if new_value == current_health:
		return

	if new_value > max_health:
		new_value = max_health
	if new_value <= 0:
		new_value = 0
		health_zeroed()
	
	current_health = new_value

func exit_combat():
	current_health = get_max_health()
	#purge status effects

func health_zeroed():
	alive = false
	emit_signal("unit_died")

func deploy():
	current_health = get_max_health()
	alive = true
	#reactivate passives
