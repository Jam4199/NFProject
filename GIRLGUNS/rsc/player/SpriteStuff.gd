extends Node2D
class_name SpriteStuff

@onready var front : Node2D = get_node("AsterFront")
@onready var back : Node2D = get_node("AsterBack")
@onready var left : Node2D = get_node("AsterLeft")
@onready var right : Node2D = get_node("AsterRight")

var faces : Array[Node2D] = [front,back,left,right]

enum {FRONT,BACK,LEFT,RIGHT}
var current_face = 0

func _ready() -> void:
	faces = [front,back,left,right]
	face(current_face)

func face(new_face : int):
	if new_face == current_face:
		return
	current_face = new_face
	for n in range(0,faces.size()):
		faces[n].visible = n == current_face
