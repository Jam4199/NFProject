extends Node

var static_delta : float = float(1.0)/float(60.0)

#World
var PlayerBulletLayer : Node2D
var EnemyBulletLayer : Node2D
var VFXLayer : Node2D

#Bullet Cap
var bullet_max_life : float = 120
var bullet_max_travel : float = 30000

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

