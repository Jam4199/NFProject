extends Node2D
class_name SpriteController

@export var anim_player : AnimationPlayer


@onready var hurt_player : AnimationPlayer = get_node("HurtAnim")
@onready var hurt_cd : Timer = get_node("hurt_cd")
@onready var action_cd : Timer = get_node("action_cd")
@onready var turn_cd : Timer = get_node("turn_cd")

var character : Character
enum side{LEFT = -1, RIGHT = 1}



func reset_anims():
	hurt_cd.stop()
	action_cd.stop()
	hurt_player.play("reset")
	if anim_player != null:
		anim_player.play("reset")


func active_animation(delta : float):
	if not action_cd.is_stopped():
		return
	if character.move_target != null:
		
		if turn_cd.is_stopped():
			var new_turn := Vector2.ZERO
			if character.move_target.x < character.position.x:
				new_turn = Vector2(-1, 1)
			elif character.move_target.x > character.position.x:
				new_turn = Vector2(1,1)
			if new_turn != Vector2.ZERO:
				if scale != new_turn:
					scale = new_turn
					turn_cd.start()
		
		if anim_player == null:
			return
		
		if anim_player.has_animation("move"):
			if anim_player.current_animation != "move":
				anim_player.play("move")
		
	return

func play_action(string : String,direction : int = 1, anim_time : float = -1):
	if anim_player == null:
		return
	if not anim_player.has_animation(string):
		if not anim_player.has_animation("attack"):
			return
		string = "attack"
	
	face(direction)
	anim_player.play(string)
	if anim_time < 0:
		action_cd.wait_time = anim_player.get_animation(string).length
	else:
		action_cd.wait_time = anim_time
	action_cd.start(anim_time)
	

func face(facing : side):
	scale = Vector2(facing,1)

func play_death():
	if anim_player == null:
		return
	
	anim_player.play("death")
	

func hurt_animation(forced : bool = false):
	print("recieved hurt anim")
	if hurt_cd.is_stopped() or forced:
		print("hurt anim")
		if scale.x >= 0:
			hurt_player.play("hurt")
		else:
			hurt_player.play("hurt_r")
		hurt_cd.start()

	
	return
