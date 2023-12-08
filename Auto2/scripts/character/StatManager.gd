extends Node2D
class_name StatManager

@export var base_max_health : float = 100
@export var base_attack : float = 20
@export var base_defense : float = 10
@export var base_evasion : float = 10
@export var base_attack_speed : float = 1

@export_group("Affinities")
@export var red : float = 1

var max_health : float
var attack : float
var defense : float
var attack_speed : float

var base_stats : Dictionary = {}

signal get_stat_adds(stat : String, adds : Array)
signal get_stat_mults(stat : String, mults : Array)
signal call_passives(passive_list : Array)
signal unit_died
signal damage_taken

func _ready() -> void:
	update_base_stats()
	return

func update_base_stats():
	base_stats["max_health"] = base_max_health
	base_stats["attack"] = base_attack
	base_stats["defense"] = base_defense
	base_stats["evasion"] = base_evasion
	base_stats["attack_speed"] = base_attack_speed

func get_stat(stat : String):
	var value = base_stats[stat]
	mod_stat(stat,value)
	return value

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
