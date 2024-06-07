extends EnemyState

var markers : Array[Marker2D] = []

enum {initial,moving,charging,after}

var initial_time := 1.0
var moving_time := 0.8
var charging_time := 2.5
var after_time := 0.5

var substate : int = 0
var timer : float = 0

func _ready() -> void:
	for marker in get_children():
		markers.append(marker)

func state_enter():
	look_at(Globals.player.global_position)
	substate = initial
	timer = initial_time

func state_exit():
	for eye in unit.eye_list:
		eye.toggle(false)

func state_process(delta):
	timer -= delta
	match substate:
		initial:
			if timer <= 0:
				for eye in unit.eye_list:
					eye.toggle(true)
				substate = moving
				timer = moving_time
		moving:
			look_at(Globals.player.global_position)
			for n in range(0,8):
				unit.eye_list[n].move_toward(markers[n].global_position)
				unit.eye_list[n].look_toward(markers[n].global_rotation)
			if timer <= 0:
				substate = charging
				timer = charging_time + 0.2
				for eye in unit.eye_list:
					eye.weapon.charge_beem(charging_time)
		charging:
			if timer <= 0:
				substate = after
				timer = after_time
				for eye in unit.eye_list:
					eye.toggle(false)
		after:
			if timer <= 0:
				emit_signal("state_change","focused_tri_laser")
	
