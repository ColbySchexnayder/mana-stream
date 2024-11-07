extends Node
class_name GMManager

var Player1Deck = []
var Player2Deck = []

signal _card_select(card)
signal _card_to_mana(card)
signal _card_exhaust(card)
