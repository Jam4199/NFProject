extends Area2D
class_name Bullet

@export var key : String

var fired : bool = false
var queue_despawn : bool = false

var lifetime : float = 10
var speed : float = 100 #pixel/s
var curve : float = 0   #degrees/sec
var acceleration : float = 0 #speed/s
var min_speed : float = 100
var max_speed = 500

var spin : bool = false
var origin : Vector2
var spin_type : int = 0 # 0 = degrees/sec, 1 = arc length
var spin_speed: float = 0
var spin_cap : float = 30
var spin_rising : float = 0

func _ready():
	
	pass


func despawn():
	set_deferred("monitorable", false)
	visible = false
	self.queue_despawn = true

func fire():
	set_deferred("monitorable",true)
	fired = true
	if origin != null:
		origin = global_position
