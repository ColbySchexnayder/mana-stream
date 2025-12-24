class_name AI extends Node

#region Field
var ai_hand : Array[Card] = []
var ai_mana_zone : Array[Card] = []
var ai_summon_zone : Array[Card] = []
var ai_deck : Array[Card] = []

var player_hand : Array[Card] = []
var player_mana_zone : Array[Card] = []
var player_summon_zone :Array[Card] = []
var player_deck : Array[Card] = []

var interruptStack : Array[Card] = []
#endregion

#region Player stat values
var p1Health := 10
var p1TotalMana := 0
var p1AvailableMana := 0

var p2Health := 10
var p2TotalMana := 0
var p2AvailableMana := 0

var player_turn := 1
#endregion

var current_state : BoardState

# Define a new field based on a provided one or the current state
func set_board_state(base : BoardState = null) -> BoardState:
	var state = BoardState.new()
	
	if base == null:
		state.ai_deck = ai_deck
		state.ai_hand = ai_hand
		state.ai_mana_zone = ai_mana_zone
		state.ai_summon_zone = ai_summon_zone
		
		state.player_deck = player_deck
		state.player_hand = player_hand
		state.player_mana_zone = player_mana_zone
		state.player_summon_zone = player_summon_zone
		
		state.p1Health = p1Health
		state.p1TotalMana = p1TotalMana
		state.p1AvailableMana = p1AvailableMana
		state.p2Health = p2Health
		state.p2TotalMana =  p2TotalMana
		state.p2AvailableMana = p2AvailableMana
	else:
		state.ai_deck = base.ai_deck
		state.ai_hand = base.ai_hand
		state.ai_mana_zone = base.ai_mana_zone
		state.ai_summon_zone = base.ai_summon_zone
		
		state.player_deck = base.player_deck
		state.player_hand = base.player_hand
		state.player_mana_zone = base.player_mana_zone
		state.player_summon_zone = base.player_summon_zone
		
		state.p1Health = base.p1Health
		state.p1TotalMana = base.p1TotalMana
		state.p1AvailableMana = base.p1AvailableMana
		state.p2Health = base.p2Health
		state.p2TotalMana =  base.p2TotalMana
		state.p2AvailableMana = base.p2AvailableMana
	
	return state
	
	
func generate_children(state : BoardState = current_state):
	var new_state : BoardState = set_board_state(state)
	
	if state.player_turn == 1:
		new_state.player_turn = 2
		state.children.push_back(new_state)
		for card in state.player_hand:
			new_state = set_board_state(state)
			new_state.player_mana_zone.push_back(card)
			new_state.player_hand.erase(card)
			state.children.push_back(new_state)
			if card.cost < state.p1AvailableMana and !card.onlyWorksInMana:
				new_state = set_board_state(state)
				new_state.player_summon_zone.push_back(card)
				new_state.player_hand.erase(card)
				new_state.p1AvailableMana -= card.cost
				state.children.push_back(new_state)
		for card in state.player_mana_zone:
			if !card.exhausted:
				new_state = set_board_state(state)
				new_state.player_mana_zone.get(card.get_index()).exhausted = true
				new_state.p1AvailableMana += 1
				new_state.p1TotalMana += 1
				state.children.push_back(new_state)
		for card in state.player_summon_zone:
			pass
	else:
		new_state.player_turn = 1
		state.children.push_back(new_state)
		for card in state.ai_hand:
			new_state = set_board_state(state)
			new_state.ai_mana_zone.push_back(card)
			new_state.ai_hand.erase(card)
			state.children.push_back(new_state)
			if card.cost < state.p2AvailableMana and !card.onlyWorksInMana:
				new_state = set_board_state(state)
				new_state.ai_summon_zone.push_back(card)
				new_state.ai_hand.erase(card)
				new_state.p2AvailableMana -= card.cost
				state.children.push_back(new_state)
		for card in state.ai_mana_zone:
			if !card.exhausted:
				new_state = set_board_state(state)
				new_state.ai_mana_zone.get(card.get_index()).exhausted = true
				new_state.p2AvailableMana += 1
				new_state.p2TotalMana += 1
				state.children.push_back(new_state)
		for card in ai_summon_zone:
			pass
