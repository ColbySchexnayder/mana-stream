extends Node
class_name GMManager

var Player1Deck : Array[String] = []
var Player2Deck : Array[String] = []

signal _card_select(card: Card)
signal _card_to_mana(card: Card)
signal _card_exhaust(card: Card)
signal _card_activate(card: Card)
signal _card_refresh(card: Card)
signal _card_summon(card: Card)
signal _card_attack(card: Card)
signal _card_block(card: Card)
signal _card_add(card: Card)
signal _card_remove(card: Card)
signal _card_destroy(card: Card)
signal _add_to_mana(card: Card, manaToAdd: int)
signal _move_to_deck(card: Card)
signal _choose_defense(card: Card)
signal _resolve_summon(card: Card)

signal _interrupt(card: Card)
signal _interrupt_resolved()
signal _pass()

signal _request_field(card: Card, zone: int)
signal _request_hand(card: Card)

signal _ai_turn()
signal _player_turn()

func load_deck(saveFile: String) -> Array[String]:
	var deckFile := FileAccess.open("res://Save/"+saveFile, FileAccess.READ)
	var deck : Array[String] = []
	var cardFileName := ""
	
	var count := 0
	while true:
		cardFileName = deckFile.get_line()
		if cardFileName == "":
			break
			
		deck.push_back(cardFileName)
		count += 1
	deckFile.close()

	return deck
