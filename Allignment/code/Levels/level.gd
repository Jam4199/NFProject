extends Node2D
class_name Level

@export_group("Scores")
@export var s_rank : float = 0
@export var a_ramk : float = 0
@export var b_rank : float = 0
@export var c_rank : float = 0
@export var d_rank : float = 0





const EnemyDeathParticle = preload("res://code/Particles/EnemyDeath.tscn")
const PlayerDeathParticle = preload("res://code/Particles/PlayerDeath.tscn")
const BulletDeathParticle = preload("res://code/Particles/BulletDeath.tscn")

const KillBeam = preload("res://code/BOOLET.tscn")
const FreezeBeam = preload("res://code/FUREEZ.tscn")

var total_enemies : int = 0
var targets : Array = []
var ammo : int = 3
var lives : int = 3
var remaining_enemies : int



@onready var player = get_node("Player")
@onready var bulletlayer : Node2D = get_node("BulletLayer")
@onready var particlelayer : Node2D = get_node("%ParticleLayer")
@onready var BEAMlayer : Node2D = get_node("BEAMLayer")

@onready var wavetimertext = get_node("%TimeText")
@onready var wavetimer = get_node("%Timer")
@onready var enemycounter = get_node("%EnemyCounter")
@onready var scorecounter = get_node("%ScoreCounter")

@onready var endscore = get_node("%EndScore")
@onready var enemyscore = get_node("%EnemyScore")
@onready var bulletscore = get_node("%BulletScore")
@onready var ammoscore = get_node("%AmmoMultiplier")
@onready var lifescore = get_node("%LifeMultiplier")
@onready var finalscore = get_node("%FinalScore")
@onready var finalrank = get_node("%FinalRank")
@onready var returner : Button = get_node("%Return")

var targetkills : int = 0
var bulletkills : int = 0

var current_score: float = 0

signal game_over
var game_over_queued := false
var game_won := false
signal retry_level

func add_target(new_target : Area2D):
	targets.append(new_target)

func _ready() -> void:
	remaining_enemies = total_enemies
	player.connect("weapon_fired", Callable(self,"weapon_fired"))
	player.connect("freeze_fired", Callable(self,"freeze_fired"))
	player.connect("rammed", Callable(self,"rammed"))
	player.connect("oof", Callable(self, "player_oof"))
	
	returner.connect("pressed", Callable(self, "exit_level"))
	
	var enemies : Array = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.player = player
		remaining_enemies += 1
	update_enemycounter()
	start()

func weapon_fired(victims : Array):
	if game_over_queued:
		return
	ammo -= 1
	get_node("%AmooCounter").text = str(ammo)
	var beam = KillBeam.instantiate()
	BEAMlayer.add_child(beam)
	beam.global_position = player.global_position
	beam.global_rotation = player.global_rotation
	for victim in victims:
		if victim is Bullet:
			bulletkills += 1
			current_score += 100
			update_score()
			victim.despawn()
			
		elif victim is Enemy:
			if victim.dead:
				continue
			if victim.shielded:
				continue
			var new_particle = EnemyDeathParticle.instantiate()
			particlelayer.add_child(new_particle)
			new_particle.global_position = victim.global_position
			
			target_killed(victim)
			
		
	return

func rammed(roadkill : Enemy):
	if roadkill.dead:
		return
	if roadkill.shielded:
		return
	var new_particle = EnemyDeathParticle.instantiate()
	particlelayer.add_child(new_particle)
	new_particle.global_position = roadkill.global_position
	
	target_killed(roadkill)
	return


func freeze_fired(victims : Array):
	if game_over_queued:
		return
	var beam = FreezeBeam.instantiate()
	BEAMlayer.add_child(beam)
	beam.global_position = player.global_position
	beam.global_rotation = player.global_rotation
	for victim in victims:
		if victim is Bullet:
			victim.despawn()
			
		elif victim is Enemy:
			victim.freeze()
	return

func player_oof():
	if game_won:
		return
	lives -= 1
	get_node("%LifeCounter").text = str(lives)
	if lives == 0:
		create_particle(PlayerDeathParticle,player.global_position)
		player.die()
		
		await get_tree().create_timer(3,false).timeout
		show_endcard()
	else:
		player.kaboom()

func bullet_made(new_bullet : Bullet):
	bulletlayer.bullet_made(new_bullet)

func target_killed(target : Enemy):
	targetkills += 1
	current_score += 10000
	update_score()
	create_particle(EnemyDeathParticle, target.global_position)
	target.die()
	remaining_enemies -= 1
	update_enemycounter()
	if remaining_enemies == 0:
		victory()

func update_score():
	scorecounter.text = str(current_score)

func update_enemycounter():
	enemycounter.text = str(remaining_enemies)


func victory():
	game_over_queued = true
	game_won = true
	#insert victory fanfare here
	await get_tree().create_timer(3,false).timeout
	show_endcard()



func show_endcard():
	
	enemyscore.text =  "[right]" + str(targetkills * 10000) + "[/right]"
	bulletscore.text = "[right]" + str(bulletkills * 100) + "[/right]"
	ammoscore.text = "[right]" + str(100 + (ammo * 20)) + "%[/right]"
	lifescore.text = "[right]" + str(100 + (lives * 20)) + "%[/right]"
	var final : float = ((targetkills * 10000) + (bulletkills * 100)) * (1 + (ammo * 0.2)) * (1 + (lives * 0.2))
	finalscore.text = "[right]" + str(final) + "[/right]"
	finalrank.text = "[right]" + check_rank(final) +"[/right]"
	
	
	var endcard :Tween = create_tween()
	endcard.tween_property(endscore,"position",Vector2(0,0),1)
	await get_tree().create_timer(2,false).timeout
	returner.visible = true
	

func check_rank(final : float) -> String:
	if final >= s_rank:
		return "SSS"
	if final >= a_ramk:
		return "SS"
	if final >= b_rank:
		return "S"
	if final >= c_rank:
		return "A"
	if final >= d_rank:
		return "B"
	return "C"

func exit_level():
	emit_signal("game_over")

func retry():
	emit_signal("retry_level")

func start():
	return

func create_particle(particle_scene : PackedScene, origin : Vector2):
	var new_particle : CPUParticles2D = particle_scene.instantiate()
	particlelayer.add_child(new_particle)
	new_particle.global_position = origin
	new_particle.emitting = true


