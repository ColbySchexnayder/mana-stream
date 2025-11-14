extends Node
class_name GMManager

@warning_ignore_start("unused_signal")

var Player1Deck : Array[String] = []
var Player2Deck : Array[String] = []



enum phase {
	REFRESH,
	PLAY,
	INTERRUPT,
	INTERRUPTP1,
	INTERRUPTP2
}

var currentPhase := phase.PLAY
var currentTurn := 1
var attacking := false

#finish action signal YES
signal _draw(player: int)
signal _shuffle(player: int)

signal _card_select(card: Card)
signal _clear_selection()

signal _offer_selection(triggerCard: Card, zonesToSelect: Array[int], matchConditions: Dictionary)

signal _action(card: Card)
signal _anim_resolved

signal _card_to_mana(card: Card)
signal _card_exhaust(card: Card)
signal _card_activate(card: Card)
signal _card_refresh(card: Card)
signal _card_summon(card: Card)
signal _resolve_summon(card: Card)
signal _card_attack(card: Card)
signal _card_block(card: Card)
signal _block_resolved
signal _card_add(card: Card)
signal _card_remove(card: Card)

signal _card_destroy(card: Card)

signal _add_to_mana(card: Card, manaToAdd: int)
signal _move_to_deck(card: Card)
signal _move_to_hand(card: Card)
signal _move_to_summon(card: Card)
signal _choose_defense(card: Card)
signal _card_keep(card: Card)


signal _interrupt(card: Card)
signal _check_interrupt()
signal _interrupt_resolved()
signal _pass()

signal _request_field(card: Card)
signal _request_hand(card: Card)

signal _interrupt_empty

signal _change_phase()
signal _change_turn()

signal _ai_turn()
signal _ai_sustain()
signal _ai_play()

signal _player_turn()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func load_deck(saveFile: String) -> Array[String]:
	var deckFile := FileAccess.open("res://Save/"+saveFile, FileAccess.READ)
	var deck : Array[String] = []
	var cardFileName := ""
	
	
	while true:
		cardFileName = deckFile.get_line()
		if cardFileName == "":
			break
			
		deck.push_back(cardFileName)
		
	deckFile.close()

	return deck
