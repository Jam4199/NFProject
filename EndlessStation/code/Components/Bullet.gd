extends Area2D

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

@export var despawn_trigger : Node2D 



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

