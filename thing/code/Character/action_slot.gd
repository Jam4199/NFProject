extends Node
class_name ActionSlot


var action_owner : Character

var used : bool = false
var available : bool = false
var speed : int = 0

var base_target : ActionSlot
var final_target : ActionSlot

func get_card() -> CombatCard:
	if get_children().size() == 0:
		return null
	else:
		return get_child(0)











