extends Node
class_name Stance

@export var basic_attack : Action

@export var passives : Array[Node]

@export_group("Stat_Addition")
@export var attack_add : float = 0
@export var defense_add : float = 0
@export var max_health_add : float = 0
@export var custom_stat_adds : Dictionary = {}


@export_group("Stat_Multiplers")
@export var move_speed_mult : float = 1
@export var attack_speed_mult : float = 1
@export var attack_mult : float = 1
@export var defense_mult : float = 1
@export var max_health_mult : float = 1
@export var custom_stat_mults : Dictionary = {}

@export_group("Ressistance")
@export var fire_res : float
@export var cold_res : float
@export var elec_res : float

