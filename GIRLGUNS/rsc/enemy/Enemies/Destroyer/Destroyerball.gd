extends EnemyBullet

var accel : float = -200
var min_speed : float = 250

func _physics_process(delta):
	super(delta)
	if speed > min_speed:
		speed += accel * delta
		if speed < min_speed:
			speed = min_speed
			#print("min_speed")
