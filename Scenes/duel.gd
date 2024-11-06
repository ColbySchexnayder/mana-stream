extends Node2D

var player1deck := []
var player1hand := []
var player1summon := []
var player1mana := []

var player2deck := []
var player2hand := []
var player2summon := []
var player2mana := []

var playersTurn := true

@onready var p_1_summon_zone: HBoxContainer = $Control/Player1Zone/P1SummonZone
@onready var p_1_mana_zone: HBoxContainer = $Control/Player1Zone/P1ManaZone
@onready var p_1_hand: HBoxContainer = $Control/Player1Zone/P1Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		var drawnCard = Card.constructor()
		drawnCard.currentPosition = Card.position.IN_HAND
		player1hand.push_front(drawnCard)
		p_1_hand.add_child(drawnCard)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var p1HandSeperationRatio = p_1_hand.get_global_rect().size.x / (player1hand.size()+1)
	p_1_hand.add_theme_constant_override("separation", p1HandSeperationRatio)
	
	var p1ManaSeperationRatio = p_1_mana_zone.get_global_rect().size.x / (player1mana.size()+1)
	p_1_mana_zone.add_theme_constant_override("seperation", p1ManaSeperationRatio)
	
	var p1SummonSeperationRatio = p_1_summon_zone.get_global_rect().size.x / (player1summon.size()+1)
	p_1_summon_zone.add_theme_constant_override("seperation", p1SummonSeperationRatio)

func _on_p_1_deck_pressed() -> void:
	var drawnCard = Card.constructor()
	drawnCard.currentPosition = Card.position.IN_HAND
	player1hand.push_front(drawnCard)
	p_1_hand.add_child(drawnCard)
