extends EnemyState

@onready var a : Node2D = get_node("a")
@onready var b : Node2D = get_node("b")

@onready var a_pos : Array = a.get_children()
@onready var b_pos : Array = b.get_children()


var a_eyes : Array[InnerEye] = []
var b_eyes : Array[InnerEye] = []
var eye_radius = 200
var current_eyes : int = 0


var shots_fired : Array[int] = [0,0]

var initial_speed : float = 400
var acceleration : float = 400
var speed : float = 2000

enum {initial, allign,waiting, chasing, charging, reset}
var substate : int = 0
var timer : float = 0

var initial_time : float = 0.5
var allign_time : float = 1
var reset_time : float = 2
var charge_time : float = 1.5
var move_time : float = 1
var wait_time : float = 0.5
var total_shots : int = 3


func enemy_ready():
	for n in range(0,4):
		a_eyes.append(unit.eye_list[n])
	for n in range(4,8):
		b_eyes.append(unit.eye_list[n])

func state_enter():
	for eye in unit.eye_list:
		eye.toggle(false)
		eye.inner_locked = false
	a.rotation = 0
	b.rotation = 0
	for center in [a,b]:
		center.position = Vector2(0,0)
	substate = initial
	timer = initial_time
	for n in [0,1]:
		shots_fired[n] = 0
	print("initial")

func state_process(delta):
	timer -= delta
	match substate:
		initial:
			if timer <= 0:
				print("allign")
				substate = allign
				timer = allign_time
				
			for n in range(1,4):
				for eye in unit.eye_list:
					eye.toggle(true)
				a_eyes[n].move_toward(a_pos[n-1].global_position)
				b_eyes[n].move_toward(b_pos[n-1].global_position)
		allign:
			if timer <= 0:
				print("waiting")
				
				substate = waiting
				timer = wait_time
				current_eyes = 0
				speed = initial_speed
				
				for n in range(1,4):
					a_eyes[n].inner_locked = true
					b_eyes[n].inner_locked = true
				
				for fired in shots_fired:
					fired = 0
					
		waiting:
			if timer <= 0:
				substate = chasing
				speed = initial_speed
				print("chasing")
		chasing:
			var ab : Array[Node2D] = [a,b]
			speed += acceleration * delta
			if ab[current_eyes].global_position.distance_to(Globals.player.global_position) > speed * delta:
				ab[current_eyes].global_position += (Vector2.from_angle(ab[current_eyes].global_position.angle_to_point(Globals.player.global_position)) * speed * delta)
			else:
				ab[current_eyes].global_position = Globals.player.global_position
				substate = charging
				timer = charge_time
				match current_eyes:
					0:
						for eye in a_eyes:
							eye.weapon.charge_beem(charge_time)
					1:
						for eye in b_eyes:
							eye.weapon.charge_beem(charge_time)
			move_eyes()
		charging:
			if timer <= 0:
				shots_fired[current_eyes] += 1
				if shots_fired[0] >= total_shots and shots_fired[1] >= total_shots:
					print("reset")
					substate = reset
					timer = reset_time
					for eye in unit.eye_list:
						eye.toggle(false)
						eye.inner_locked = false
				else:
					print("waiting")
					
					substate = waiting
					timer = wait_time
					current_eyes = (current_eyes + 1)%2
		reset:
			
			if timer <= 0:
				emit_signal("state_change","spread_beam")
	
	
	
	return


func move_eyes():
	a_eyes[0].move_target = Vector2.from_angle(global_position.angle_to_point(a.global_position) + (PI/2)) * 120
	a_eyes[0].look_at(a.global_position)
	b_eyes[0].move_target = Vector2.from_angle(global_position.angle_to_point(b.global_position) + (-PI/2)) * 120
	b_eyes[0].look_at(b.global_position)
	
	for n in range(1,4):
		a_eyes[n].global_position = a_pos[n-1].global_position
		a_eyes[n].look_at(a.global_position)
		
		b_eyes[n].global_position = b_pos[n-1].global_position
		b_eyes[n].look_at(b.global_position)
		
		if substate == chasing:
			match current_eyes:
				0:
					a_eyes[n].look_at(Globals.player.global_position)
				1:
					b_eyes[n].look_at(Globals.player.global_position)
	
	
	
	















