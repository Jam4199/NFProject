extends Node2D

var bullet_layer : Node2D
var bullet_storage : Dictionary = {}
var bullet_list : Array = [
	
]

func _ready() -> void:

	for filepath in bullet_list:
		mass_load_bullets(filepath)
	


func return_bullet(bullet):
	var key = bullet.key
	bullet_storage[key]["top_bullet"] += 1
	bullet_storage[key]["bullets"][bullet_storage[key]["top_bullet"]] = bullet

func mass_load_bullets(filepath : String):
	var loading_bullet : PackedScene = load(filepath)
	var temp_bullet : Bullet = loading_bullet.instantiate()
	var new_bullet : Bullet
	bullet_storage[temp_bullet.key] = {}
	bullet_storage[temp_bullet.key]["bullets"] = []
	bullet_storage[temp_bullet.key]["bullets"].resize(500)
	bullet_storage[temp_bullet.key]["top_bullet"] = int(499)
	for n in range(0,500):
		new_bullet = loading_bullet.instantiate()
		new_bullet.connect("return_bullet",Callable(self,"return_bullet"))
		bullet_storage[temp_bullet.key]["bullets"][n] = new_bullet
	temp_bullet.queue_free()

func take_bullet(key : String) -> Bullet:
	var bullet : Bullet = bullet_storage[key]["bullets"][bullet_storage[key]["top_bullet"]]
	bullet_storage[key]["bullets"][bullet_storage[key]["top_bullet"]] = null
	bullet_storage[key]["top_bullet"] -= 1
	return bullet
