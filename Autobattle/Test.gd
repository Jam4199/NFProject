extends Node2D

var nums : Array[Vector3] = [
	Vector3(200,100,0),
	Vector3(150,100,20),
	Vector3(200,100,20),
	Vector3(200,200,0),
	Vector3(150,200,20),
	Vector3(200,200,20)
]



var vec1 := Vector2(-100,0)
var vec2 := Vector2(100,0)


var val = 10
func _ready() -> void:
	for num in nums:
		calc(num)
	print("wao")
	for num in nums:
		bcalc(num)
	
	var move_angle : float = vec1.angle_to_point(vec2)
	var move_distance : float = vec1.distance_to(vec2)
	var follow_point : Vector2 = vec1 + Vector2.from_angle(move_angle) * (move_distance - 5)
	print(str(follow_point))
	
	
	return

func calc(stats : Vector3):
	print(str(
		stats.x - (stats.x * ((stats.y - stats.z)/ (stats.y + val)))
		))

func bcalc(stats : Vector3):
	print(str(
		stats.x - (stats.x * ((stats.y * ((100 - stats.z )/ 100))/ (stats.y + val)))
		))
