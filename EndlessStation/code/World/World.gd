extends Node2D
class_name World

func _ready() -> void:
	BulletManager.DangerLayer = get_node("Dangers")
	BulletManager.PlayerBulletLayer = get_node("PlayerBullets")

