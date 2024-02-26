extends Bullet


func _ready() -> void:
	super()
	monitorable = false

func activate():
	set_deferred("monitorable",true)

func deactivate():
	set_deferred("monitorable",false)
