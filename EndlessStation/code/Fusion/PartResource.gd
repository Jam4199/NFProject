extends Node2D
class_name PartResource

@export var energy_req : float = 0
@export var material_req : float = 0

@export_group("Pickups")
@export_subgroup("Upgrades")
@export var health_up : float = 0
@export var energy_up : float = 0

@export_subgroup("Resources")
@export var materials : float = 0
@export var supplies : float = 0
@export var population : int = 0

@export_subgroup("Weapons")
@export var guns : bool = false
