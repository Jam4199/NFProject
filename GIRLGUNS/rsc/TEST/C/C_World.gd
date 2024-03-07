extends World

const CHASER = preload("res://rsc/enemy/Enemies/Chaser/Chaser.tscn")
const CRUSHER = preload("res://rsc/enemy/Enemies/Crusher/Crusher.tscn")
const SHOOTER = preload("res://rsc/enemy/Enemies/Shooter/Shooter.tscn")
const DESTROYER = preload("res://rsc/enemy/Enemies/Destroyer/Destroyer.tscn")

@onready var timer : Timer = get_node("Timer")
@onready var spawn : Node2D = get_node("EnemyLayerMid/Spawn")

func _ready() -> void:
	timer.connect("timeout", Callable(self,"timer_end"))
	

func timer_end():
	var new_enemy = CHASER.instantiate()
	Globals.add_enemy(new_enemy)
	new_enemy.global_position = spawn.global_position
	new_enemy.spawn()
	#timer.stop() #activate to spawn only once
