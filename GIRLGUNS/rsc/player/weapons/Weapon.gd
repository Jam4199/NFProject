extends Node2D
class_name Weapon

@export var ui_name : String = "Weapon"
@export var icon : Texture = null #40x40?
@export_group("Base Stats")
@export var base_magazine_size : int = 10
@export var base_rof : float = 2 #fire per second
@export var base_reload_time : float = 3 #seconds
@export var base_spread : float = 2 #degrees for both sides
@export var base_shots : int = 1 #shots per second
@export var base_burst_shot : bool = false
@export var base_burst_count : int = 3 #shots per burst
@export var base_burst_gap : float = 1 #time between bursts

#final stats

var magazine_size : int = 10
var rof : float = 2 #fire per second
var reload_time : float = 3 #seconds
var spread : float = 2 #degrees for both sides
var shots : int = 1 #shots per fire
var burst_shot : bool = false
var burst_count : int = 3 #shots per burst
var burst_gap : float = 1 #time between bursts

#bullet modifiers
var damage_multiplier : float = 1
var damage_add : float = 0
var speed_multiplier : float = 1
var pierce_add : int = 0
var aoe_override : int = 0 #-1 to disable, +1 to enable
var aoe_add : float
var hit_scan_override : int = 0 #-1 to disable, +1 to enable


#variables
var ammo : int = 0
var player_shoot : bool = false

#non base stat
var multishot : int = 1

#timers
var reload_timer : float = 0
var shot_counter : float = 0
var burst_counter : int = 0
var burst_timer : float = 0

#modifier checks

#world events
signal bullet_created(new_bullet : Bullet)
signal shot_fired(bullet_shot : Bullet)
signal last_shot_fired(bullet_shot : Bullet)

func update_stats():
	magazine_size = base_magazine_size
	rof = base_rof
	reload_time = base_reload_time
	spread = base_spread
	shots = base_shots
	burst_shot = base_burst_shot
	burst_count = base_burst_count
	burst_gap = base_burst_gap
	return

func reset(reload : bool = true):
	update_stats()
	if reload:
		ammo = magazine_size
	else:
		ammo = 0

func is_shooting()->bool:
	if ammo <= 0:
		return false
	
	if burst_shot:
		if burst_counter == burst_count:
			return player_shoot
		if burst_counter > 0:
			return true
		return false
	
	return player_shoot


func _physics_process(delta : float):
	if burst_shot:
		if burst_timer > 0:
			burst_timer -= 0
			if burst_timer <= 0:
				burst_counter = burst_count
	
	
	if is_shooting():
		shoot_command(delta)
		reload_timer = reload_time
		shot_counter += (rof * delta)
		if burst_counter > 0:
			burst_counter -= 1
			if burst_counter <= 0:
				burst_timer = burst_gap
	else:
		if shot_counter < 1:
			shot_counter += (rof * delta)
			if shot_counter > 1:
				shot_counter = 1
		if ammo < magazine_size:
			reload_timer -= delta
			if reload_timer <= 0:
				reload_complete()
	
	if burst_shot:
		if burst_counter <= 0 and burst_timer <= 0:
			burst_timer = burst_gap
	return


func shoot_command(delta : float):
	if burst_shot and burst_timer > 0:
		return
	if ammo <= 0:
		return
	
	shot_counter += (rof * delta)
	var shot_cap : int = 10
	if shot_counter >= 1:
		shot_counter *= shots
	while shot_counter >= 1 and shot_cap > 0:
		if ammo <= 0:
			break 
		shot_counter -= 1
		shot_cap -= 1
		ammo -= 1
		
		if burst_shot:
			if burst_counter <= 0:
				break
			burst_counter -= 1
		
		var bullet_shot : Bullet = shoot()
		emit_signal("shot_fired", bullet_shot)
		if ammo == 0:
			emit_signal("last_shot_fired", bullet_shot)
	
	return


func reload_complete():
	if burst_shot:
		burst_timer = 0
		burst_counter = burst_count
	ammo = magazine_size
	
	return


func shoot()-> Bullet: #interface
	
	return null

func create_bullet(bullet_scene : PackedScene, new_position : Vector2, new_rotation_degrees : float)-> Bullet:
	var new_bullet : Bullet = bullet_scene.instantiate()
	Globals.add_bullet(new_bullet) #add child to world
	modify_bullet(new_bullet)
	new_bullet.global_position = new_position
	new_bullet.global_rotation_degrees = new_rotation_degrees
	new_bullet.connect("bullet_hit",Callable(self,"bullet_hit"))
	return new_bullet

func modify_bullet(bullet : Bullet):
	bullet.damage = bullet.base_damage * damage_multiplier
	bullet.damage += damage_add
	bullet.speed = bullet.base_speed + speed_multiplier
	bullet.pierce = bullet.base_pierce + pierce_add
	if aoe_override > 0:
		bullet.aoe = true
	if aoe_override < 0:
		bullet.aoe = false
	if aoe_override == 0:
		bullet.aoe = bullet.base_aoe
	if bullet.aoe:
		bullet.aoe_size = bullet.base_aoe_size + aoe_add 

func bullet_hit(hit_count : int):
	return






