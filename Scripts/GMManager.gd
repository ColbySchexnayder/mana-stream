extends Node
class_name GMManager

var Player1Deck : Array[String] = []
var Player2Deck : Array[String] = []

signal _card_select(card)
signal _card_to_mana(card)
signal _card_exhaust(card)
signal _card_activate(card)
signal _card_refresh(card)
signal _card_summon(card)
signal _card_attack(card)
signal _card_block(card)
signal _card_add(card)
signal _card_remove(card)
signal _card_destroy(card)
signal _add_to_mana(card, manaToAdd)
signal _move_to_deck(card)
signal _choose_defense(card)
signal _resolve_summon(card)

signal _interrupt(card)
signal _interrupt_resolved()
signal _pass()

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
