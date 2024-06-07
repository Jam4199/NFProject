extends Enemy
class_name  Eater

@onready var eye00 : TSubWep = get_node("%Subwep0")
@onready var eye30 : TSubWep = get_node("%Subwep1")
@onready var eye60 : TSubWep = get_node("%Subwep2")
@onready var eye90 : TSubWep = get_node("%Subwep3")
@onready var eye120 : TSubWep = get_node("%Subwep4")
@onready var eye150 : TSubWep = get_node("%Subwep5")
@onready var eye180 : TSubWep = get_node("%Subwep6")
@onready var eye210 : TSubWep = get_node("%Subwep7")
@onready var eye240 : TSubWep = get_node("%Subwep8")
@onready var eye270 : TSubWep = get_node("%Subwep9")
@onready var eye300 : TSubWep = get_node("%Subwep10")
@onready var eye330 : TSubWep = get_node("%Subwep11")

@onready var l_mouth : Mouth = get_node("%LMouths")
@onready var r_mouth : Mouth = get_node("%RMouths")

var mouths : Array[Mouth]
var eyelist : Array[TSubWep]


func _ready() -> void:
	mouths = [l_mouth,r_mouth]
	
	
	l_mouth.attachment = get_node("%LPoint")
	r_mouth.attachment = get_node("%RPoint")
	l_mouth.partner = r_mouth
	r_mouth.partner = l_mouth
	
	for mouth in mouths:
		Globals.world.runprogress.modify_enemy(mouth)
		mouth.knockback_immune = true

	knockback_immune = true
	eyelist = [eye00,eye30,eye60,eye90,eye120,eye150,eye180,eye210,eye240,eye270,eye300,eye330]
	super()

func change_state(state : String):
	super(state)
	print("next_state : " + state)
