extends Node2D

var player1deck := []
var player1hand := []
var player1summon := []
var player1mana := []

var player2deck := []
var player2hand := []
var player2summon := []
var player2mana := []

var totalMana := 0
var availableMana := 0

var inspectedCard

var playersTurn := true


@onready var player_1_zone: VBoxContainer = $Control/Player1Zone

@onready var p_1_summon_zone: HBoxContainer = $Control/Player1Zone/P1SummonZone
@onready var p_1_mana_zone: HBoxContainer = $Control/Player1Zone/P1ManaZone
@onready var p_1_hand: HBoxContainer = $Control/Player1Zone/P1Hand
@onready var inspection_area: Control = $Control/InspectionArea/CenterContainer
@onready var p_1_mana: RichTextLabel = $Control/P1Mana

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		var drawnCard = Card.constructor()
		drawnCard.currentPosition = Card.position.IN_HAND
		player1hand.push_front(drawnCard)
		p_1_hand.add_child(drawnCard)
		
		
	player1deck = GmManager.Player1Deck
	player2deck = GmManager.Player2Deck
	GmManager.connect("_card_select", card_select)
	GmManager.connect("_card_to_mana", card_to_mana)
	GmManager.connect("_card_exhaust", card_exhaust)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var p1HandSeperationRatio = player_1_zone.get_global_rect().size.x / (player1hand.size()+1)
	p_1_hand.add_theme_constant_override("separation", p1HandSeperationRatio)
	
	var p1ManaSeperationRatio = player_1_zone.get_global_rect().size.x / (player1mana.size()+1)
	p_1_mana_zone.add_theme_constant_override("separation", p1ManaSeperationRatio)
	
	var p1SummonSeperationRatio = player_1_zone.get_global_rect().size.x / (player1summon.size()+1)
	p_1_summon_zone.add_theme_constant_override("separation", p1SummonSeperationRatio)
	
	p_1_mana.text = str(availableMana) + "/" + str(totalMana)

func card_to_mana(card):
	player1mana.push_front(card)
	player1hand.erase(card)
	card.reparent(p_1_mana_zone)
	
	
	totalMana += 1

func card_select(card):
	if inspection_area.get_child_count() == 0:
		card.reparent(inspection_area)
		card.inspect_view.visible = true
		card.card_back.visible = false
		card.card_front.visible = true
		card.card_back.scale.x = 1
		card.card_back.scale.y = 1
	elif inspection_area.get_child(0) == card:
		card.inspect_view.visible = false
		match (card.currentPosition):
			card.position.IN_HAND:
				card.reparent(p_1_hand)
			card.position.IN_MANA:
				card.reparent(p_1_mana_zone)
				if not card.revealed:
					card.card_back.visible = true
					card.card_front.visible = false
				if card.exhausted:
					card.card_back.scale.x = .5
					card.card_back.scale.y = .5
				
	

func card_exhaust(card):
	if card.exhausted:
		return
		
	availableMana += 1
	
func _on_p_1_deck_pressed() -> void:
	var drawnCard = Card.constructor()
	drawnCard.currentPosition = Card.position.IN_HAND
	player1hand.push_front(drawnCard)
	p_1_hand.add_child(drawnCard)


func _on_node_2d_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
