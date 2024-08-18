extends Node
class_name Character

@export var max_guard : int = 60
@export var max_hp : int = 80

@export var base_slots : int = 1
@export var deck : Array[CardData]

@onready var combat_deck : Node = get_node("CombatDeck")
@onready var combat_hand : Node = get_node("CombatHand")
@onready var action_slots : Array[ActionSlot] = [get_node("ActionSlot0"),get_node("ActionSlot1"),get_node("ActionSlot2")]
@onready var defense_slot : ActionSlot = get_node("DefenseSlot")

var current_hp : int = 80
var current_guard : int = 60

func _ready():
	current_hp = max_hp
	for slot in action_slots:
		slot.action_owner = self

func enter_combat(clear : bool = true):
	
	current_guard = max_guard
	current_hp = max_hp
	
	if  clear:
		clear_combat_cards()
	
	for card in deck:
		var new_card := CombatCard.new()
		new_card.card_data = card
		combat_deck.add_child(new_card)

func recieve_damage(value : int, dice_type : int = 3):
	current_hp -= value
	if current_hp <= 0:
		current_hp = 0
		#dies

func recieve_stagger(value : int, dice_type : int = 3):
	current_guard -= value
	if current_guard <= 0:
		current_guard = 0
	return


func death():
	for slot in action_slots:
		if slot.get_card() != null:
			slot.get_card().dice_list = []
		

func clear_combat_cards():
	
	for child in combat_deck.get_children():
		child.queue_free()
	
	for child in combat_hand.get_children():
		child.queue_free()
	
	for slot in action_slots:
		for child in slot.get_children():
			child.queue_free()
	
	defense_slot.get_card().dice_list = []










