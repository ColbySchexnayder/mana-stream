extends Node
class_name GMManager

var Player1Deck = []
var Player2Deck = []

signal _card_select(card)
signal _card_to_mana(card)
signal _card_exhaust(card)
signal _card_activate(card)
signal _card_refresh(card)
signal _card_summon(card)
signal _card_attack(card)
signal _card_block(card)
signal _card_destroy(card)
signal _add_to_mana(card, manaToAdd)
signal _move_to_deck(card)
signal _choose_defense(card)
signal _resolve_summon(card)
signal _pass()
