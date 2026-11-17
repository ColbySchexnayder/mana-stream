class_name Pilot extends Resource

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

##Functions to be overridden by Pilot Personalities
##Comments give a general layout of how the funtions will be used
##Other comments in AI_Manager.gd should be helpful for general direction of personalities

func ai_turn():
	pass

func decider():
	pass

func sustain_decider():
	pass

#Handles interrupt abilities that come from AI's cards
func handle_interrupt(card: Card):
	pass

#isolated function to choose defense
#not an action that can be taken during the AI turn so doesn't need to be evaluated
func choose_defense(card: Card):
	pass

#Chooses card from list offered from abilities
func choose_card(list: Array[Card]) -> Card:
	return list[0]

#Chooses a card to spend mana to keep on the field
func sustain():
	pass

#Moves from the sustain phase to the turn proper
func change_phase():
	pass

#Evaluator for sustaining more cards
#Checks against moving to the turn
#Is it necessary to make this an evaluator?
func e_sustain():
	pass

#Evaluator for changing the phase to the main part of the turn
#Has to be balanced with choosing to sustain more cards
#Is it necessary to make this an evaluator
func e_change_phase():
	pass

#Evaluates whether the turn should be passed back to the player
#Should minimize wasted moves, but this will be the most dependant on the "personality" of the pilot
func e_end_turn():
	pass

#Ends the turn passing it to the player
func end_turn():
	pass

#Evaluates whether to attack
#Depends on personality, but guranteed damage should alway lead to an attack
func e_attack():
	pass

#Choose a card an attack with it
#Depends on personality but should always choose an attack that leads to victory
func attack():
	pass

#Evaluates whether to activate a cards ability
#Typically if a card can activate an ability, it probably should
func e_activate():
	pass

#Chooses a card that has an ability to activate and activates it
func activate():
	pass

#Evaulates whether to put more cards in the summon zone
func e_to_field():
	pass

#Spends mana to send a card to the field
#Will heavily depend on Pilot's personality to choose the best card
#A swarm of rats and cats can't remove a bear or a hawk, but are an effective blockade to draw more resources
func to_field():
	pass

#Evaluates if more mana should be played
#Mana only cards should be played first
func e_to_mana():
	pass

#Sends a card from the hand to the mana zone
func to_mana():
	pass

#Taps mana to pay to send card to field
func tap_for_mana():
	pass
