class_name AI_Manager extends Node



var ai_hand : Array[Card] = []
var ai_mana_zone : Array[Card] = []
var ai_summon_zone : Array[Card] = []
var ai_deck : Array[Card] = []

var player_hand : Array[Card] = []
var player_mana_zone : Array[Card] = []
var player_summon_zone :Array[Card] = []
var player_deck : Array[Card] = []

var interruptStack : Array[Card] = []

#region Player stat values
var p1Health := 10
var p1TotalMana := 0
var p1AvailableMana := 0

var p2Health := 10
var p2TotalMana := 0
var p2AvailableMana := 0
#endregion


# choosing defense won't be counted in the list of actions
# instead handled in isolation
var actions = {
	"to_mana" : to_mana,
	"tap_for_mana" : tap_for_mana,
	"to_field" : to_field,
	"activate" : activate, 
	"attack" : attack,
	"end_turn" : end_turn,
	}
var action_evaluators = {
	"to_mana" : e_to_mana,
	"tap_for_mana" : e_tap_for_mana,
	"to_field" : e_to_field,
	"activate" : e_activate, 
	"attack" : e_attack,
	"end_turn" : e_end_turn,
}
var sustain_evaluators = {
	"sustain" : e_sustain,
	"change_phase" : e_change_phase,
}
var sustain_actions = {
	"sustain" : sustain,
	"change_phase" : change_phase,
}
var players_turn = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#GmManager.connect("_ai_turn", ai_turn)
	GmManager.connect("_interrupt", handle_interrupt)
	
#TODO: Move evaluators and actions here
func _process(delta: float) -> void:
	if players_turn:
		return
	if GmManager.currentPhase == GmManager.phase.REFRESH:
		sustain_decider()
	else:
		decider()
	
# During the enemies turn, sorts through cards and decides an appropriate reaction.
# This repeats until ending the turn is the best action
func decider():
	
	var best_action : String
	var highest_score : float
	
	
	best_action = ""
	highest_score = -INF
	
	for action in action_evaluators.keys():
		var score : float = action_evaluators[action].call()
		#TODO: remove debug print
		print(action, ": ", score)
		if score > highest_score:
			best_action = action
			highest_score = score
	
	print("Best action: ", best_action, "\n\n")
	await actions[best_action].call()
	

#Seperate decider for the sustain phase to keep things clean
func sustain_decider():
	if ai_summon_zone.is_empty():
		change_phase()
	
	var best_action : String
	var highest_score : float
	
	
	best_action = ""
	highest_score = -INF
	
	for action in sustain_evaluators.keys():
		var score : float = sustain_evaluators[action].call()
		#TODO: remove debug print
		print(action,  ": ",  score)
		if score > highest_score:
			best_action = action
			highest_score = score
	
	print("Best sustain action: ", best_action, "\n\n")
	await sustain_actions[best_action].call()

#TODO: This all needs to be changed!
#TODO: Seriously don't ignore this

func ai_sustain():
	#if !ai_summon_zone.is_empty():
		#ai_hand[0].mana()
		#ai_mana_zone[0].mana()
		#GmManager.emit_signal("_card_keep", ai_summon_zone[0])
		#
	#GmManager.emit_signal("_change_phase")
	sustain_decider()

func ai_play():
	#if !ai_summon_zone.is_empty():
		#ai_summon_zone[0].attacking()
		#while !interruptStack.is_empty():
			#await GmManager._interrupt_resolved
		#
		#await GmManager._block_resolved
		#
	#GmManager.emit_signal("_change_turn")
	decider()

func choose_card(list: Array[Card]) -> Card:
	return list[0]

func handle_interrupt(card: Card):
	if card.cardOwner == 1:
		return

# If there are cards to defend with prioritize ones
# that will survive first
# that will damage the opponents board
func choose_defense(card: Card):
	if players_turn:
		if ai_summon_zone.size() > 0:
			
			var defense = ai_summon_zone.filter(func(block_card): 
				return block_card.health > card.attack)
			if defense.is_empty():
				defense = ai_summon_zone.filter(func(block_card):
					return block_card.attack > card.health)
			
			if defense.is_empty():
				ai_summon_zone[randi() % len(ai_summon_zone)].block()
				return
			
			defense[randi() % len(defense)].block()
		else:
			GmManager.emit_signal("_pass")

#region actions to perform
func to_mana():
	
	var cards = ai_hand.filter(func(card:Card):
		card.onlyWorksInMana)
	
	if !cards.is_empty():
		cards[randi()%len(cards)].mana()
		return

func tap_for_mana():
	pass

func to_field():
	pass

func activate():
	pass

func attack():
	pass

func sustain():
	pass
	
func change_phase():
	GmManager.emit_signal("_change_phase")
	
func end_turn():
	GmManager.emit_signal("_change_turn")
#endregion

# normalize:(val, max, min) => (val - min) / (max - min); 
# Base thought: 1 -> 5/5 -> (5-val*.1)/5 -> result <= 1
#region action evaluators; should all return floats between 0 and 1
#evaluate the value of placing a card from hand to mana
#division will typically assume a minimum divisor of 1 to avoid divide by 0 errors
func e_to_mana() -> float:
	for card in ai_hand:
		if card.onlyWorksInMana:
			return 1
	
	var avg_card_cost = 0
	for card in ai_hand:
		avg_card_cost += card.cost
	
	var total_playable_cards = max(1,len(ai_hand))
	avg_card_cost = avg_card_cost/total_playable_cards

	
	var score = (avg_card_cost - p2TotalMana * .2 + p2AvailableMana * .1 + .01) / (avg_card_cost + .01)
	
	return score
	
#evaluate the value of using a card in mana zone
#Should this even be here or dealt with during playing to field?
func e_tap_for_mana()-> float:
	if ai_mana_zone.is_empty():
		return 0
		
	
	var avg_card_cost = 0
	for card in ai_hand:
		avg_card_cost += card.cost
	
	var total_playable_cards = max(1,len(ai_hand))
	avg_card_cost = avg_card_cost/total_playable_cards
	
	
	var score = (avg_card_cost + p2AvailableMana * .2 - p2TotalMana * .1 + .01)/(avg_card_cost + .01)
	
	return score
	
# Evaluates sending a card to the summon zone. Spell/Summon
func e_to_field()-> float:
	if ai_mana_zone.is_empty() or p2AvailableMana == 0:
		return 0
	
	var avg_oppenent_power = 0
	for card in player_summon_zone:
		avg_oppenent_power += card.attack
	
	var n_player_field = max(1,len(player_summon_zone))
	avg_oppenent_power = avg_oppenent_power/n_player_field
	
	var avg_ai_power = 0
	for card in ai_summon_zone:
		avg_ai_power += card.attack
	
	avg_ai_power = avg_ai_power/max(1, len(ai_summon_zone))
	var mana = len(ai_mana_zone)
	
	var score = (avg_oppenent_power - avg_ai_power * .2 + mana * .1 + 1) / (avg_oppenent_power + 1)
	
	return score
	

# This evaluator should be only need to be run during potential interrupts
# May not even need to be used
# TODO: possibly check for evaluation for cards on the board. Right now, no card does that
func e_activate()-> float:
	if ai_summon_zone.is_empty() and ai_mana_zone.is_empty():
		return 0
	
	if GmManager.currentPhase == GmManager.phase.INTERRUPT:
		return 1
	
	var score = 0
		
	return score

# evaluator for attacking
# mainly compares ai attacker versus player defense
# Should maybe also incorporate player offense
func e_attack()-> float:
	var ai_attacker = 0
	if ai_summon_zone.is_empty():
		return 0
	
	ai_attacker = ai_summon_zone.reduce(func(max, card): 
		return card if card.attack > max.attack else max).attack
	
	var player_defender = 0
	if !player_summon_zone.is_empty():
		player_summon_zone.reduce(func(max, card):
			return card if card.health > max.health else max).health
	
	ai_attacker += .01
	var score = (ai_attacker - player_defender)/(ai_attacker)
	return score



func e_sustain()-> float:
	if ai_summon_zone.is_empty():
		return 0
	
	var cost = 0
	var card = ai_summon_zone.reduce(func(card, cost):
		return cost + card.cost)
	if card:
		cost += card.cost
	
	var score = 1 - cost * .1 + p2AvailableMana * .1
	return score

func e_change_phase()-> float:
	var score = .9
	return score

# Need to make this more robust
# Right now just returns a minumum that other actions need to beat to keep the turn going
func e_end_turn()-> float:
	return .89

#TODO: Add this to the framework
func e_evaluate_target()-> float:
	return 0
#endregion
