extends Resource
class_name CardDice

@export var min_roll : int = 1
@export var max_roll : int = 10
@export var dice_type : DICE_TYPE
enum DICE_TYPE{SLASH,PIERCE,BLUNT,BLOCK,DODGE}

@export_group("Animation")
@export var string : String
@export var distance : float = 30
@export var effects : Array[PackedScene]
