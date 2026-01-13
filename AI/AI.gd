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


var scored_choices : Array[Dictionary] = []

var field_score := {
	"AI Hand" : 0,
	"AI Mana" : 0,
	"AI Summon" : 0,
	"Player Hand" : 0,
	"Player Mana" : 0,
	"Player Summon" : 0,
	"Total AI" : 0,
	"Total Player" : 0,
	"Total" : 0 #Total is AI - Player
}

#Find the current score for each section of the field
func score_field():
	score_hand(1)
	score_hand(2)
	score_mana(1)
	score_mana(2)
	score_summon(1)
	score_summon(1)
	
	field_score["Total AI"] = field_score["AI Hand"] + field_score["AI Mana"] + field_score["AI Summon"]
	field_score["Total Player"] = field_score["Player Hand"] + field_score["Player Mana"] + field_score["Player Summon"]
	
	field_score["Total"] = field_score["Total AI"] - field_score["Total Player"]

#Reward having a little in hand
func score_hand(player: int):
	if player == 1: #Score Player hand
		for h_card in player_hand:
			field_score["Player Hand"] += 1
	else: #Score AI Hand
		for h_card in ai_hand:
			field_score["AI Hand"] += 1

#Reward having mana, possibly more for archetypes like undead if they're revealed
func score_mana(player: int):
	if player == 1: #Score player mana
		for m_card in player_mana_zone:
			field_score["Player Mana"] += 1
	else: #Score AI mana
		for m_card in ai_mana_zone:
			field_score["AI Mana"] += 1

func score_summon(player: int):
	if player == 1:#Score player summon
		for s_card in player_summon_zone:
			field_score["Player Summon"] += s_card.cost
	else: #Score AI summon
		for s_card in ai_summon_zone:
			field_score["AI Summon"] += s_card.cost


func score_cards():
	match GmManager.currentPhase:
		GmManager.phase.REFRESH:
			pass
		GmManager.phase.PLAY:
			for h_card in ai_hand:
				var pseudo_card  ={
					"name" : "",
					"score" : 0,
					"action" : ""
				}
				pseudo_card["name"] = h_card.cardName
				pseudo_card["score"] += h_card.cost
				
				pass
		GmManager.phase.INTERRUPT:
			pass

#var current_state : BoardState
#
##Awful. Ineffecient. Broken. Do Not Do This
## Define a new field based on a provided one or the current state
## WARNING duplicates the card nodes to keep from effecting the field. This may be overly resource intensive
#func set_board_state(base : BoardState = null) -> BoardState:
	#var state = BoardState.new()
	#
	#if base == null:
		#state.ai_deck = ai_deck.duplicate()
		#state.ai_hand = ai_hand.duplicate()
		#state.ai_mana_zone = ai_mana_zone.duplicate()
		#state.ai_summon_zone = ai_summon_zone.duplicate()
		#
		#state.player_deck = player_deck.duplicate()
		#state.player_hand = player_hand.duplicate()
		#state.player_mana_zone = player_mana_zone.duplicate()
		#state.player_summon_zone = player_summon_zone.duplicate()
		#
		#state.p1Health = p1Health
		#state.p1TotalMana = p1TotalMana
		#state.p1AvailableMana = p1AvailableMana
		#state.p2Health = p2Health
		#state.p2TotalMana =  p2TotalMana
		#state.p2AvailableMana = p2AvailableMana
		#state.next_states.clear()
	#else:
		#state.ai_deck = base.ai_deck.duplicate()
		#state.ai_hand = base.ai_hand.duplicate()
		#state.ai_mana_zone = base.ai_mana_zone.duplicate()
		#state.ai_summon_zone = base.ai_summon_zone.duplicate()
		#
		#state.player_deck = base.player_deck.duplicate()
		#state.player_hand = base.player_hand.duplicate()
		#state.player_mana_zone = base.player_mana_zone.duplicate()
		#state.player_summon_zone = base.player_summon_zone.duplicate()
		#
		#state.p1Health = base.p1Health
		#state.p1TotalMana = base.p1TotalMana
		#state.p1AvailableMana = base.p1AvailableMana
		#state.p2Health = base.p2Health
		#state.p2TotalMana =  base.p2TotalMana
		#state.p2AvailableMana = base.p2AvailableMana
		#state.depth = base.depth + 1
		#state.next_states.clear()
		#
	#
	#return state
	#
##Generate possible changes to the field from given state
#func generate_next_states(state : BoardState = current_state):
	#var new_state : BoardState = set_board_state(state)
	#
	#if state.player_turn == 1:
		#new_state.player_turn = 2
		#new_state.ai_hand.push_back(new_state.ai_deck.pop_front())
		#new_state.node_score = new_state.calculate_score()
		#state.next_states.push_back(new_state)
		#
		#for card in state.player_hand:
			#new_state = set_board_state(state)
			#new_state.player_mana_zone.push_back(card)
			#new_state.player_hand.erase(card)
			#new_state.node_score = new_state.calculate_score()
			#state.next_states.push_back(new_state)
			#
			#if card.cost < state.p1AvailableMana and !card.onlyWorksInMana:
				#new_state = set_board_state(state)
				#new_state.player_summon_zone.push_back(card)
				#new_state.player_hand.erase(card)
				#new_state.p1AvailableMana -= card.cost
				#new_state.node_score = new_state.calculate_score()
				#state.next_states.push_back(new_state)
				#
		#for card in state.player_mana_zone:
			#if !card.exhausted:
				#new_state = set_board_state(state)
				#new_state.player_mana_zone.get(card.get_index()).exhausted = true
				#new_state.p1AvailableMana += 1
				#new_state.p1TotalMana += 1
				#new_state.node_score = new_state.calculate_score()
				#state.next_states.push_back(new_state)
				#
		#for card in state.player_summon_zone:
			#if !card.exhausted:
				#if ai_summon_zone.is_empty():
					#new_state = set_board_state(state)
					#new_state.player_summon_zone.get(card.get_index()).exhausted = true
					#new_state.p2Health -= card.attack
					#new_state.node_score = new_state.calculate_score()
					#state.next_states.push_back(new_state)
				#else:
					#for opp_card in ai_summon_zone:
						#new_state = set_board_state(state)
						#if card.attack > opp_card.health:
							#new_state.ai_deck.push_back(opp_card)
							#new_state.ai_summon_zone.erase(opp_card)
						#if opp_card.attack > card.health:
							#new_state.player_deck.push_back(card)
							#new_state.player_summon_zone.erase(card)
						#new_state.node_score = new_state.calculate_score()
						#state.next_states.push_back(new_state)
						#
	#else:
		#new_state.player_turn = 1
		#new_state.player_hand.push_back(new_state.player_deck.pop_front())
		#new_state.node_score = new_state.calculate_score()
		#state.next_states.push_back(new_state)
		#
		#for card in state.ai_hand:
			#new_state = set_board_state(state)
			#new_state.ai_mana_zone.push_back(card)
			#new_state.ai_hand.erase(card)
			#new_state.node_score = new_state.calculate_score()
			#state.next_states.push_back(new_state)
			#
			#if card.cost < state.p2AvailableMana and !card.onlyWorksInMana:
				#new_state = set_board_state(state)
				#new_state.ai_summon_zone.push_back(card)
				#new_state.ai_hand.erase(card)
				#new_state.p2AvailableMana -= card.cost
				#new_state.node_score = new_state.calculate_score()
				#state.next_states.push_back(new_state)
				#
		#for card in state.ai_mana_zone:
			#if !card.exhausted:
				#new_state = set_board_state(state)
				#new_state.ai_mana_zone.get(card.get_index()).exhausted = true
				#new_state.p2AvailableMana += 1
				#new_state.p2TotalMana += 1
				#new_state.node_score = new_state.calculate_score()
				#state.next_states.push_back(new_state)
				#
		#for card in ai_summon_zone:
			#if !card.exhausted:
				#if player_summon_zone.is_empty():
					#new_state = set_board_state(state)
					#new_state.ai_summon_zone.get(card.get_index()).exhausted = true
					#new_state.p1Health -= card.attack
					#new_state.node_score = new_state.calculate_score()
					#state.next_states.push_back(new_state)
				#else:
					#for opp_card in player_summon_zone:
						#new_state = set_board_state(state)
						#if card.attack > opp_card.health:
							#new_state.player_deck.push_back(opp_card)
							#new_state.player_summon_zone.erase(opp_card)
						#if opp_card.attack > card.health:
							#new_state.ai_deck.push_back(card)
							#new_state.ai_summon_zone.erase(card)
						#new_state.node_score = new_state.calculate_score()
						#state.next_states.push_back(new_state)
						#
	#state.next_states.sort_custom(func (state1:BoardState, state2:BoardState):
		#return state1.node_score > state2.node_score)
