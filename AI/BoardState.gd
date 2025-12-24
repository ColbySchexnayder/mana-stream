class_name BoardState

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

var node_score = 0
var children : Array[BoardState] = []

func calculate_score() -> float:
	node_score += p2Health*5 - p1Health*5
	for card in ai_hand:
		node_score += 1
	for card in ai_mana_zone:
		if card.revealed and card.cost > 0:
			node_score += card.cost
		else:
			node_score += 1
	for card in ai_summon_zone:
		node_score += card.cost
	for card in player_hand:
		node_score -= 1
	for card in player_mana_zone:
		if card.revealed and card.cost > 0:
			node_score -= card.cost
		else:
			node_score -= 1
	for card in player_summon_zone:
		node_score += card.cost
	return node_score
