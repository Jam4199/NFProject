extends Bullet
class_name Aoe

@onready var circle : CollisionShape2D = get_node("Circle")
signal pass_hit(object : Node2D)

func _ready():
	super()
	

func set_radius(radius : float):
	circle.shape.radius = radius
	
	return

func hit(object : Node2D):
	if object in pierced:
		return
	pierced.append(object)
	
	emit_signal("pass_hit",object)







