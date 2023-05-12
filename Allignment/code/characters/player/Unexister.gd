extends Area2D

var ramming : bool = false
signal slowo
signal rammed(roadkill : Enemy)

func _ready() -> void:
	connect("area_entered", Callable(self, "unexist"))
	

func unexist(area : Area2D):
	if area is Bullet:
		area.despawn()
		if ramming:
			emit_signal("slowo")
	if ramming and area is Enemy:
		emit_signal("rammed", area)
		return
