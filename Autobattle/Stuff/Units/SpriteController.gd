extends Node2D
class_name SpriteController

@onready var animplayer : AnimationPlayer = get_node("AnimationPlayer")
@onready var sprite : Node2D = get_node("Sprite")

var walking : bool = false : set = set_walking
var unit : Unit

func set_walking(new_walking : bool):
	if animplayer.current_animation == "idle":
		if animplayer.has_animation("walking"):
			animplayer.play("walking")
	walking = new_walking

func walk(side : int):
	#if animplayer.current_animation == "idle":
	face(side)

func face(side : int):
	scale = Vector2(side,1)

func play_animation(anim : String, force : bool = false):
	if not unit.is_alive() and force == false:
		if animplayer.current_animation != "death":
			animplayer.play("death")
		return
	
	
	if animplayer.has_animation(anim):
		animplayer.play(anim)
		
	
	return

func reset():
	scale = Vector2(1,1)
	if animplayer.get_animation_library_list().has("idle"):
		animplayer.play("idle")
