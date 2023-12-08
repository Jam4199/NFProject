extends Hurtbox
class_name Bullet

@export var key : String

var fired : bool = false
var queue_despawn : bool = false

var velocity := Vector2(0,0) #pixel/s
var curve_deg : float = 0   #degrees/sec
var curve_cap : float = 360
var accel : float = 0 #speed/s
var accel_cap : float = 500

var current_curve : float = 0

var pierce : int = 0
var pierced : Array = []

@export var despawn_trigger : Node2D 

@export_group("limit")
@export var lifespan : float = 30
var lifetime : float = 0
@export var max_travel : float = 3000
var total_travel : float = 0

@export_group("VFX")
@export var hit_vfx : PackedScene
#@export var despawn_vfx : PackedScene
#@export var target_attach_vfx : PackedScene
#@export var target_attach_point : PackedScene


signal speed_mod_requested(mod : Array)
signal bullet_moved

func hit(hitbox : HitBox):
	super(hitbox)
	
	if hit_vfx != null:
		VFXManager.create_vfx(hit_vfx,global_position)
	
	if pierce <= 0:
		despawn()
	else:
		pierce -= 1
		pierced.append(hitbox)

func despawn():
	if despawn_trigger !=null:
		if despawn_trigger.has_method("trigger"):
			despawn_trigger.trigger()
	set_deferred("monitorable", false)
	visible = false
	self.queue_despawn = true

func fire():
	set_deferred("monitorable",true)
	fired = true

