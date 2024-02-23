extends Node

var records : Records
var world : World
var player : Player
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func add_bullet(new_bullet : Bullet):
	if world == null:
		return
	world.add_bullet(new_bullet)

func add_effect(new_effect : Node2D):
	if world == null:
		return
	world.add_effect(new_effect)

func add_enemy(new_enemy : Enemy):
	if world == null:
		return
	world.add_enemy(new_enemy)
