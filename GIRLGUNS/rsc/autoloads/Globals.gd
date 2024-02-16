extends Node

var world : World
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func add_bullet(new_bullet : Bullet):
	if world == null:
		return
	world.add_bullet(new_bullet)
	print("bullet_added")

func add_effect(new_effect : Node2D):
	if world == null:
		return
	world.add_effect(new_effect)
