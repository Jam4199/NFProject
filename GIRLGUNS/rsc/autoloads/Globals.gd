extends Node

var records : Records
var world : World
var player : Player
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func add_bullet(new_bullet : Bullet):
	if world == null:
		return
	world.add_bullet(new_bullet)

func add_effect(new_effect : Node2D,front : bool = true):
	if world == null:
		return
	world.add_effect(new_effect , front)

func add_enemy(new_enemy : Enemy):
	if world == null:
		return
	world.add_enemy(new_enemy)
	new_enemy.connect("enemy_death", Callable(world,"enemy_death"))

func add_enemy_bullet(new_bullet : EnemyBullet):
	if world == null:
		return
	world.add_enemy_bullet(new_bullet)
