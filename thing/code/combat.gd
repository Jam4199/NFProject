extends Node
class_name Combat

func combat_start():
	var action_slots : Array[ActionSlot] = []
	# get action slots
	for action_slot in action_slots:
		if action_slot.get_card() != null:
			action_slot.get_card().load_dice()
			card_effect(action_slot.get_card(), CardData.on_use, action_slot, action_slot.final_target)

func action_use(action : ActionSlot):
	if action.final_target.final_target == action:
		clash_sequence(action, action.final_target)

func clash_sequence(action_a, action_b):
	var card_a : CombatCard = action_a.get_card()
	var card_b : CombatCard = action_b.get_card()
	
	
	card_a.card_data.card_effect(CardData.on_use,action_a,action_b)
	card_b.card_data.card_effect(CardData.on_use,action_b,action_a)
	
	while card_a.dice_list.size() + card_b.dice_list.size() > 0:
		if card_a.dice_list.size() <= 0:
			one_side(action_b,action_a)
		elif card_b.dice_list.size() <= 0:
			one_side(action_a,action_b)
		else:
			clash(action_a,action_b)

func one_side(attacker:ActionSlot,reciever:ActionSlot):
	var attacker_dice : CombatDice = attacker.get_card().dice_list[0]
	if attacker_dice.dice_type in [CardDice.DICE_TYPE.BLOCK,CardDice.DICE_TYPE.DODGE]:
		attacker.action_owner.defense_slot.get_card().dice_list.append(attacker_dice)
		attacker.get_card().dice_list.remove_at(0)
		return
	
	if reciever.action_owner.defense_slot.get_card().dice_list.size() > 0:
		clash(attacker, reciever.action_owner.defense_slot)
		return
	
	dice_effect(attacker_dice, CardData.one_side,attacker,reciever)
	
	attacker_dice.roll_dice()
	var final_power : int = attacker_dice.final_power()
	reciever.action_owner.recieve_damage(final_power,attacker_dice.dice_typee)
	
	dice_effect(attacker_dice, CardData.on_hit,attacker,reciever)
	return

func clash(action_a : ActionSlot, action_b : ActionSlot):
	var card_a : CombatCard = action_a.get_card()
	var card_b : CombatCard = action_b.get_card()
	
	card_a.card_data.card_effect(CardData.on_clash,action_a,action_b)
	card_b.card_data.card_effect(CardData.on_clash,action_b,action_a)
	
	var clash_win : Callable = func clash_win(winner : ActionSlot, loser : ActionSlot):
		
		var card_w : CombatCard = winner.get_card()
		var card_l : CombatCard = loser.get_card()
		
		card_w.card_data.card_effect(CardData.clash_win,winner,loser)
		card_l.card_data.card_effect(CardData.clash_lose,loser,winner)
		
		match card_w.dice_list[0].dice_type:
			CardDice.DICE_TYPE.DODGE:
				if not card_l.dice_list[0].dice_type in [CardDice.DICE_TYPE.BLOCK,CardDice.DICE_TYPE.DODGE]:
					card_w.reuse_dice()
				#insert stag rec here
			CardDice.DICE_TYPE.BLOCK:
				loser.action_owner.recieve_stagger(card_w.dice_list[0].final_power())
			var attack_type:
				var damage : int = card_w.dice_list[0].final_damage()
				if card_l.dice_list[0].dice_type == CardDice.DICE_TYPE.BLOCK:
					damage -= card_l.dice_list[0].final_power()
				loser.action_owner.recieve_damage(damage,attack_type)
				loser.action_owner.recieve_stagger(damage,attack_type)
				dice_effect(card_w.dice_list[0],CardData.on_hit,winner,loser)
		
		card_w.next_dice()
		card_l.next_dice()
		
		
		
		
		return
	
	card_a.dice_list[0].roll_dice()
	card_b.dice_list[0].roll_dice()
	
	if card_a.dice_list[0].final_power() > card_b.dice_list[0].final_power():
		clash_win.call(action_a,action_b)
	elif card_b.dice_list[0].final_power() > card_a.dice_list[0].final_power():
		clash_win.call(action_b,action_a)
	else:
		card_a.next_dice()
		card_b.next_dice()
	
	
	
	return

func dice_effect(dice : CombatDice, input : int, caster : ActionSlot, target : ActionSlot):
	if dice.card_data == null:
		return
	dice.card_data.dice_effect(dice.dice_slot,input,caster,target)
	return

func card_effect(card : CombatCard, input, caster : ActionSlot, target : ActionSlot):
	if card.card_data == null:
		return
	card.card_data.card_effect(input, caster, target)















