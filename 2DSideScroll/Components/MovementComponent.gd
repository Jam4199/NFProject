extends Node
class_name Movement

@export var target : Node2D
@export var base_speed : float = 100

@export_group("Connections")
@export var cardinalcheck : Node2D

@export_group("Body")
@export var override : bool = false
@export var slide : bool = false
@export var x_only : bool = false

var disabled : bool = false

var current_speed : float
var speed_multiplier : float = 1

var direction : Vector2
var velocity : Vector2


signal speed_declared
signal speed_mod_requested(mods : Array)
signal direction_declared
signal velocity_declared



func _ready() -> void:
	
	return

func move_order(new_direction : Vector2):
	
	current_speed = base_speed
	speed_multiplier = 1
	emit_signal("speed_declared")
	var speed_mod : Array = []
	emit_signal("speed_mod_requested", speed_mod)
	for mod in speed_mod:
		if mod is float:
			speed_multiplier *= mod
	current_speed *= speed_multiplier
	
	direction = new_direction
	if cardinalcheck != null:
		direction = cardinalcheck.border_check(direction)
	emit_signal("direction_declared")
	
	velocity = direction * current_speed
	emit_signal("velocity_declared")

func _physics_process(delta: float) -> void:
	var prev : Vector2 = target.global_position
	
	if disabled:
		return
	
#	if velocity == Vector2(0,0):
#		return
	
	if target == null:
		return
	
	if target is CharacterBody2D and override == false:
		if slide:
			if x_only:
				target.velocity.x = velocity.x
			else:
				target.velocity = velocity
			target.move_and_slide()
		else:
			if target.move_and_collide(velocity * Globals.static_delta,false,0) != null:
				target.global_position = prev
	else:
		if x_only:
			target.global_position.x += velocity.x * Globals.static_delta
		else:
			target.global_position += velocity * Globals.static_delta




