extends Node

var main : Main
var records : Records
var world : World
var player : Player
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var upgrademenu : Control
var gameover : GameOver

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
	return new_enemy

func add_enemy_bullet(new_bullet : EnemyBullet):
	if world == null:
		return
	world.add_enemy_bullet(new_bullet)

func player_death():
	world.pause()
	await get_tree().create_timer(2).timeout
	gameover.visible = true

func return2title():
	main.game_reset()
	gameover.visible = false
	return
