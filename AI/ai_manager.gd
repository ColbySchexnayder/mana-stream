class_name AI_Manager extends Node



var ai_hand := []
var ai_mana_zone := []
var ai_summon_zone := []
var ai_deck := []

var player_hand := []
var player_mana_zone := []
var player_summon_zone := []
var player_deck := []

var interruptStack : Array[Card] = []

# choosing defense won't be counted in the list of actions
# instead handled in isolation
var actions = {
	"to_mana" : to_mana,
	"use_for_mana" : use_for_mana,
	"to_field" : to_field,
	"activate" : activate, 
	"attack" : attack,
	"end_turn" : end_turn,
	}
var action_evaluators = {
	"to_mana" : e_to_mana,
	"use_for_mana" : e_use_for_mana,
	"to_field" : e_to_field,
	"activate" : e_activate, 
	"attack" : e_attack,
	"end_turn" : e_end_turn,
}
var sustain_evaluators = {
	"use_for_mana" : e_use_for_mana,
	"sustain" : e_sustain,
	"change_phase" : e_change_phase,
}
var sustain_actions = {
	"use_for_mana" : use_for_mana,
	"sustain" : sustain,
	"change_phase" : change_phase,
}
var players_turn = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#GmManager.connect("_ai_turn", ai_turn)
	GmManager.connect("_interrupt", handle_interrupt)
	

# During the enemies turn, sorts through cards and decides an appropriate reaction.
# This repeats until ending the turn is the best action
func decider():
	
	var best_action : String
	var highest_score : float
	
	while best_action != "end_turn":
		best_action = ""
		highest_score = -INF
		
		for action in action_evaluators.keys():
			var score : float = action_evaluators[action]
			if score > highest_score:
				best_action = action
				highest_score = score
		
		actions[best_action]
	

#Seperate decider for the sustain phase to keep things clean
func sustain_decider():
	if ai_summon_zone.is_empty():
		change_phase()
	

#TODO: This all needs to be changed!
#TODO: Seriously don't ignore this

func ai_sustain():
	if !ai_summon_zone.is_empty():
		ai_hand[0].mana()
		ai_mana_zone[0].mana()
		GmManager.emit_signal("_card_keep", ai_summon_zone[0])
		
	GmManager.emit_signal("_change_phase")

func ai_play():
	if !ai_summon_zone.is_empty():
		ai_summon_zone[0].attacking()
		while !interruptStack.is_empty():
			await GmManager._interrupt_resolved
		
		await GmManager._block_resolved
		
	GmManager.emit_signal("_change_turn")

func choose_card(list: Array[Card]) -> Card:
	return list[0]

func handle_interrupt(card: Card):
	if card.cardOwner == 1:
		return

func choose_defense(card: Card):
	if players_turn:
		if ai_summon_zone.size() > 0:
			ai_summon_zone[0].block()
		else:
			GmManager.emit_signal("_pass")

#region actions to perform
func to_mana():
	pass

func use_for_mana():
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

#region action evaluators; should all return floats between 0 and 1
func e_to_mana() -> float:
	return 0

func e_use_for_mana()-> float:
	return 0

func e_to_field()-> float:
	return 0

func e_activate()-> float:
	return 0

func e_attack()-> float:
	return 0

func e_change_phase()-> float:
	return 0

func e_sustain()-> float:
	return 0

func e_end_turn()-> float:
	return 0
#endregion
