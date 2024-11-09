extends Node2D

var player1deck := []
var player1hand := []
var player1summon := []
var player1mana := []

var player2deck := []
var player2hand := []
var player2summon := []
var player2mana := []

var health := 10
var totalMana := 0
var availableMana := 0

var p2Health := 10
var p2TotalMana := 0
var p2AvailableMana := 0

var inspectedCard

var playersTurn := true
var attacking := false
var attackingCard


@onready var player_1_zone: VBoxContainer = $Control/Player1Zone

@onready var p_1_summon_zone: HBoxContainer = $Control/Player1Zone/P1SummonZone
@onready var p_1_mana_zone: HBoxContainer = $Control/Player1Zone/P1ManaZone
@onready var p_1_hand: HBoxContainer = $Control/Player1Zone/P1Hand
@onready var inspection_area: Control = $Control/InspectionArea/CenterContainer
@onready var p_1_mana: RichTextLabel = $Control/P1Mana
@onready var p_1_life: RichTextLabel = $Control/P1Life

@onready var p_2_life: RichTextLabel = $Control/P2Life
@onready var p_2_mana: RichTextLabel = $Control/P2Mana
@onready var player_2_zone: VBoxContainer = $Control/Player2Zone

@onready var p_2_hand: HBoxContainer = $Control/Player2Zone/P2Hand
@onready var p_2_mana_zone: HBoxContainer = $Control/Player2Zone/P2ManaZone
@onready var p_2_summon_zone: HBoxContainer = $Control/Player2Zone/P2SummonZone

@onready var ai: AI_Manager = $AI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		var drawnCard = Card.constructor()
		drawnCard.currentPosition = Card.position.IN_HAND
		player1hand.push_front(drawnCard)
		p_1_hand.add_child(drawnCard)
		
		var opponentsCard = Card.constructor()
		opponentsCard.cardOwner = 2
		opponentsCard.currentPosition = Card.position.IN_HAND
		opponentsCard.revealed = false
		
		player2hand.push_front(opponentsCard)
		p_2_hand.add_child(opponentsCard)
		opponentsCard.card_front.visible = false
		opponentsCard.card_back.visible = true
	
	var opponentsDefense = Card.constructor()
	opponentsDefense.cardOwner = 2
	opponentsDefense.currentPosition = Card.position.IN_SUMMON
	p_2_summon_zone.add_child(opponentsDefense)
	player2summon.push_front(opponentsDefense)
	
	p_1_life.text = str(health)
	p_2_life.text = str(p2Health)
	
	player1deck = GmManager.Player1Deck
	player2deck = GmManager.Player2Deck
	
	
	ai.ai_deck = player2deck
	ai.ai_hand = player2hand
	ai.ai_mana_zone = player2mana
	ai.ai_summon_zone = player2summon
	
	ai.player_deck = player1deck
	ai.player_hand = player1hand
	ai.player_summon_zone = player1summon
	ai.player_mana_zone = player1mana
	
	GmManager.connect("_card_select", card_select)
	GmManager.connect("_card_to_mana", card_to_mana)
	GmManager.connect("_card_summon", card_summon)
	GmManager.connect("_add_to_mana", add_to_mana)
	GmManager.connect("_card_attack", card_attack)
	GmManager.connect("_move_to_deck", move_to_deck)
	GmManager.connect("_card_block", card_block)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var p1HandSeperationRatio = player_1_zone.get_global_rect().size.x / (player1hand.size()+1)
	p_1_hand.add_theme_constant_override("separation", p1HandSeperationRatio)
	
	var p1ManaSeperationRatio = player_1_zone.get_global_rect().size.x / (player1mana.size()+1)
	p_1_mana_zone.add_theme_constant_override("separation", p1ManaSeperationRatio)
	
	var p1SummonSeperationRatio = player_1_zone.get_global_rect().size.x / (player1summon.size()+1)
	p_1_summon_zone.add_theme_constant_override("separation", p1SummonSeperationRatio)
	
	p_1_mana.text = str(availableMana) + "/" + str(totalMana)
	
	
	var p2HandSeperationRatio = player_2_zone.get_global_rect().size.x / (player2hand.size()+1)
	p_2_hand.add_theme_constant_override("separation", p2HandSeperationRatio)
	
	var p2ManaSeperationRatio = player_2_zone.get_global_rect().size.x / (player2mana.size()+1)
	p_2_mana_zone.add_theme_constant_override("separation", p2ManaSeperationRatio)
	
	var p2SummonSeperationRatio = player_2_zone.get_global_rect().size.x / (player2summon.size()+1)
	p_2_summon_zone.add_theme_constant_override("separation", p2SummonSeperationRatio)
	
	p_2_mana.text = str(p2AvailableMana) + "/" + str(p2TotalMana)

func card_to_mana(card):
	player1mana.push_front(card)
	player1hand.erase(card)
	card.reparent(p_1_mana_zone)
	card.inspect_view.visible = false
	card.revealed = false
	
	
	totalMana += 1

func card_select(card):
	if (card.cardOwner == 2 and !card.revealed):
		return
		
	if inspection_area.get_child_count() == 0:
		card.reparent(inspection_area)
		card.inspect_view.visible = true
		card.card_back.visible = false
		card.card_front.visible = true
		card.card_back.scale.x = 1
		card.card_back.scale.y = 1
		card.card_front.scale.x = 1
		card.card_front.scale.y = 1
		if card.cardOwner == 1:
			if card.currentPosition == card.position.IN_HAND:
				card.summon_button.visible = true
			if card.currentPosition == card.position.IN_SUMMON and !card.exhausted:
				if !attacking:
					card.attack_button.visible = true
				elif !playersTurn:
					card.block_button.visible = true
			if card.currentPosition == card.position.IN_DECK:
				card.call_deferred("queue_free")
			
	elif inspection_area.get_child(0) == card:
		card.inspect_view.visible = false
		card.summon_button.visible = false
		card.attack_button.visible = false
		card.block_button.visible = false
		if card.exhausted:
			card.card_back.scale.x = .5
			card.card_back.scale.y = .5
			card.card_front.scale.x = .5
			card.card_front.scale.y = .5
		match (card.currentPosition):
			card.position.IN_HAND:
				if card.cardOwner == 1:
					card.reparent(p_1_hand)
				else:
					card.reparent(p_2_hand)
			card.position.IN_MANA:
				if card.cardOwner == 1:
					card.reparent(p_1_mana_zone)
					if not card.revealed:
						card.card_back.visible = true
						card.card_front.visible = false
				else:
					card.reparent(p_2_mana_zone)
				
			card.position.IN_SUMMON:
				if card.cardOwner == 1:
					card.reparent(p_1_summon_zone)
				else:
					card.reparent(p_2_summon_zone)
				
	

func card_summon(card):
	if card.currentPosition != card.position.IN_HAND:
		return
	if card.cost <= availableMana:
		availableMana -= card.cost
		player1summon.push_front(card)
		player1hand.erase(card)
		card.reparent(p_1_summon_zone)
		card.currentPosition  = card.position.IN_SUMMON
		card.summon_button.visible = false
		card.inspect_view.visible = false

func move_to_deck(card):
	if card.cardOwner == 1:
		player1deck.push_back(card)
		match card.currentPosition:
			card.position.IN_SUMMON:
				player1summon.erase(card)
			card.position.IN_MANA:
				player1mana.erase(card)
			card.position.IN_HAND:
				player1hand.erase(card)
	else:
		player2deck.push_back(card)
		match card.currentPosition:
			card.position.IN_SUMMON:
				player2summon.erase(card)
			card.position.IN_MANA:
				player2mana.erase(card)
			card.position.IN_HAND:
				player2hand.erase(card)
	
	card.currentPosition = Card.position.IN_DECK
	
	card.call_deferred("queue_free")
	
	for c in player1deck:
		print(c.cardName)

func add_to_mana(card, manaToAdd):
	availableMana += manaToAdd

func card_attack(card):
	card_select(card)
	if playersTurn and player2summon.size() == 0:
		GmManager.emit_signal("_card_exhaust", card)
		p2Health -= card.attack
		p_2_life.text = str(p2Health)
		if p2Health == 0:
			pass #TODO GAME VICTORY CODE HERE
		return
	attackingCard = card
	attacking = true
	GmManager.emit_signal("_choose_defense", card)
	

func card_block(card):
	if (attackingCard.attack > card.health):
		card.destroy()
	if (card.attack > attackingCard.health):
		attackingCard.destroy()
	
	attacking = false

func card_battle(attack_card, block_card):
	pass


func _on_p_1_deck_pressed() -> void:
	var drawnCard = Card.constructor()
	drawnCard.currentPosition = Card.position.IN_HAND
	player1hand.push_front(drawnCard)
	p_1_hand.add_child(drawnCard)


func _on_node_2d_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.


func _on_pass_button_pressed() -> void:
	pass # Replace with function body.
