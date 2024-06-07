extends Enemy
class_name Eater

@onready var eye_list : Array[InnerEye] = []

func _ready() -> void:
	for eye in get_node("Eyes").get_children():
		if eye is InnerEye:
			eye_list.append(eye)
			eye.fade()
			eye.spawn()
			eye.master = self
			eye.knockback_immune = true
	super()



func _physics_process(delta: float) -> void:
	super(delta)





