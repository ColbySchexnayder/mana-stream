extends Node2D

#region The field. 
#Easier to access arrays than getting children from the control nodes
var player1deck : Array[Card]= []
var player1hand : Array[Card]= []
var player1summon : Array[Card]= []
var player1mana : Array[Card]= []

var player2deck  : Array[Card]= []
var player2hand : Array[Card]= []
var player2summon : Array[Card]= []
var player2mana : Array[Card]= []

var field = [
	player1deck, 
	player1hand, 
	player1summon, 
	player1mana,
	player2deck, 
	player2hand, 
	player2summon, 
	player2mana
	]
#endregion

#TODO: This will be required before AI can be worked on
var interruptStack : Array[Card] = []

#region Player stat values
var health := 10
var totalMana := 0
var availableMana := 0

var p2Health := 10
var p2TotalMana := 0
var p2AvailableMana := 0
#endregion
#A place to store the currently selected card
var inspectedCard

#Turn managment variables
var currentTurn := 1
var attackingCard : Card

#Used to return a card to it's position in a given zone when no longer selected
var cardIndex


#region Script accessible screen nodes
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

@onready var p_1_deck: PanelContainer = $Control/P1Deck
@onready var p_2_deck: PanelContainer = $Control/P2Deck
@onready var p_1_deck_holder: Control = $P1DeckHolder
@onready var p_2_deck_holder: Control = $P2DeckHolder

@onready var interrupt_choice: Control = $Control/InterruptChoice

@onready var turn_label: RichTextLabel = $Control/TurnLabel
@onready var phase_label: RichTextLabel = $Control/PhaseLabel
@onready var interception_message: RichTextLabel = $Control/InterruptChoice/Panel/InterceptionMessage

@onready var ai: AI_Manager = $AI

@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var phase_change_animation: AnimatedSprite2D = $PhaseChangeAnimation

@onready var selection_list_area: TextureRect = $Control/SelectionListArea
@onready var selection_list: ItemList = $Control/SelectionListArea/SelectionList

#endregion

#Preloading necessary files
const CLICK_3 = preload("res://Sfx/UI Audio/Audio/click3.ogg")
const CAST_BUTTON = preload("res://Art/castButton.png")
const SUMMON_BUTTON = preload("res://Art/summonButton.png")

#Signals only used within the duel script
signal choice_made(num)

# Prepare the duel
func _ready() -> void:
	#Language adjustments
	interception_message.text = tr("ACTIVATION_QUESTION")
	
	#region Load Decks
	for cardFileName in GmManager.Player1Deck:
		var card = ResourceLoader.load("res://Cards/PlayableCards/"+cardFileName+".tscn").instantiate()#load("res://Cards/PlayableCards/"+cardFileName+".tscn")
		player1deck.push_back(card)
		p_1_deck_holder.add_child(card)
	
	#If the computer doesn't have a deck to load just copy the players
	if GmManager.Player2Deck.is_empty():
		GmManager.Player2Deck = GmManager.Player1Deck.duplicate(true)
	
	for cardFileName in GmManager.Player2Deck:
		var card = ResourceLoader.load("res://Cards/PlayableCards/"+cardFileName+".tscn").instantiate()#load("res://Cards/PlayableCards/"+cardFileName+".tscn")
		card.cardOwner = 2
		player2deck.push_back(card)
		p_2_deck_holder.add_child(card)
	#endregion
	
	#Shuffle the decks
	randomize()
	player1deck.shuffle()
	player2deck.shuffle()
	
	#Draw the starting hand
	for i in range(5):
		draw(1)
		draw(2)
	
	#region Add Test Cards
	#var testSpell1 = Veterinarian.constructor()
	#testSpell1.cardOwner = 1
	#testSpell1.currentPosition = Card.position.IN_HAND
	#player1hand.push_front(testSpell1)
	#p_1_hand.add_child(testSpell1)
#
	#var testSpell = Briarpatch.constructor()
	#testSpell.currentPosition = Card.position.IN_HAND
	#player1hand.push_front(testSpell)
	#p_1_hand.add_child(testSpell)
	#
	#
	#var opponentsDefense = Card.constructor()
	#opponentsDefense.revealed = true
	#opponentsDefense.cardOwner = 2
	#opponentsDefense.currentPosition = Card.position.IN_SUMMON
	#p_2_summon_zone.add_child(opponentsDefense)
	#player2summon.push_front(opponentsDefense)
	#endregion
	
	#initialize the text that shows health
	p_1_life.text = str(health)
	p_2_life.text = str(p2Health)
	
	#Give the ai a copy of the field
	ai.ai_deck = player2deck
	ai.ai_hand = player2hand
	ai.ai_mana_zone = player2mana
	ai.ai_summon_zone = player2summon
	
	ai.player_deck = player1deck
	ai.player_hand = player1hand
	ai.player_summon_zone = player1summon
	ai.player_mana_zone = player1mana
	
	ai.interruptStack = interruptStack
	
	#region Initialize signals
	GmManager.connect("_card_select", card_select)
	GmManager.connect("_clear_selection", deselect)
	
	GmManager.connect("_offer_selection", offer_selection)
	
	GmManager.connect("_card_to_mana", card_to_mana)
	GmManager.connect("_card_summon", card_summon)
	GmManager.connect("_move_to_summon", move_to_summon)
	GmManager.connect("_add_to_mana", add_to_mana)
	GmManager.connect("_card_attack", card_attack)
	GmManager.connect("_move_to_deck", move_to_deck)
	GmManager.connect("_move_to_hand", move_to_hand)
	GmManager.connect("_card_block", card_block)
	
	GmManager.connect("_card_keep", card_keep)
	GmManager.connect("_change_turn", change_turn)
	GmManager.connect("_change_phase", change_phase)
	
	GmManager.connect("_interrupt", interrupt)
	GmManager.connect("_check_interrupt", check_interrupt)
	
	GmManager.connect("_request_field", requestField)
	
	GmManager.connect("_draw", draw)
	GmManager.connect("_shuffle", shuffle)
	#endregion
	
	#Give AI mana for testing
	#Needs to be done after signals are connected otherwise "card_to_mana" won't work
	#player2hand[0].mana()
	

# Keep the text up to date and cards organized
func _process(_delta: float) -> void:
	#Keep player 1 cards the right distance apart
	var p1HandSeperationRatio = player_1_zone.get_global_rect().size.x / (player1hand.size()+1)
	p_1_hand.add_theme_constant_override("separation", p1HandSeperationRatio)
	
	var p1ManaSeperationRatio = player_1_zone.get_global_rect().size.x / (player1mana.size()+1)
	p_1_mana_zone.add_theme_constant_override("separation", p1ManaSeperationRatio)
	
	var p1SummonSeperationRatio = player_1_zone.get_global_rect().size.x / (player1summon.size()+1)
	p_1_summon_zone.add_theme_constant_override("separation", p1SummonSeperationRatio)
	
	#Show player 1 available mana out of total mana
	p_1_mana.text = str(availableMana) + "/" + str(totalMana)
	
	#Keep player 2 cards the right distance apart
	var p2HandSeperationRatio = player_2_zone.get_global_rect().size.x / (player2hand.size()+1)
	p_2_hand.add_theme_constant_override("separation", p2HandSeperationRatio)
	
	var p2ManaSeperationRatio = player_2_zone.get_global_rect().size.x / (player2mana.size()+1)
	p_2_mana_zone.add_theme_constant_override("separation", p2ManaSeperationRatio)
	
	var p2SummonSeperationRatio = player_2_zone.get_global_rect().size.x / (player2summon.size()+1)
	p_2_summon_zone.add_theme_constant_override("separation", p2SummonSeperationRatio)
	
	#Show player 2 available mana out of total mana
	p_2_mana.text = str(p2AvailableMana) + "/" + str(p2TotalMana)
	
	#Show current turn and phase
	turn_label.text = "Player " + str(currentTurn)
	phase_label.text = str(GmManager.phase.keys()[GmManager.currentPhase])
	
	p_1_life.text = str(health)
	p_2_life.text = str(p2Health)
	
	#region keep the ai up to date
	ai.p1Health = health
	ai.p1TotalMana = totalMana
	ai.p1AvailableMana = availableMana
	ai.p2Health = p2Health
	ai.p2TotalMana = p2TotalMana
	ai.p2AvailableMana = p2AvailableMana
	
	ai.ai_deck = player2deck
	ai.ai_hand = player2hand
	ai.ai_mana_zone = player2mana
	ai.ai_summon_zone = player2summon
	
	ai.player_deck = player1deck
	ai.player_hand = player1hand
	ai.player_summon_zone = player1summon
	ai.player_mana_zone = player1mana
	
	ai.interruptStack = interruptStack
	#endregion
	
	check_interrupt()

func shuffle(player: int):
	if player == 1:
		player1deck.shuffle()
	else:
		player2deck.shuffle()



#Draw card from @player deck. Place it in hand
func draw(player: int):
	match player:
		1:
			var card = player1deck.pop_front()
			player1hand.push_back(card)
			card.reparent(p_1_hand)
			card.currentPosition = Card.position.IN_HAND
			
		2:
			var card = player2deck.pop_front()
			player2hand.push_back(card)
			card.reparent(p_2_hand)
			card.currentPosition = Card.position.IN_HAND
			
			#Keep the player from seeing the computer's hand
			card.revealed = false
			card.card_front.visible = false
			card.card_back.visible = true

#Select @card and move it to the center of the screen with its inspection window viewable
func card_select(card):
	#The player can't see the AI's card unless it has been revealed
	if (card.cardOwner == 2 and !card.revealed):
		return
	#The player can only inspect one card at a time
	if inspection_area.get_child_count() != 0:
		deselect()
		return

	sfx_player.stream = CLICK_3
	sfx_player.play()
	
	#Remember the position of the card in it's given zone
	cardIndex = card.get_index()
	
	#Move the card to the selection area
	card.reparent(inspection_area)
	
	#Make the front visible if it wasn't already
	card.inspect_view.visible = true
	card.card_back.visible = false
	card.card_front.visible = true
	card.card_art.visible = true
	
	#Even if the card is exhausted we want to see it it full scale when inspected
	card.card_back.scale.x = 1
	card.card_back.scale.y = 1
	card.card_front.scale.x = 1
	card.card_front.scale.y = 1
	card.card_art.scale.x = 1
	card.card_art.scale.y = 1
	
	#If it's the player's card show the appropriate buttons
	if card.cardOwner == 1:
		#Most buttons are only valid on the player's turn
		if interruptStack.has(card):
				card.action_button.visible = true
		if currentTurn == 1:
			#A card in the hand can be sent to MANA or SUMMON in the PLAY phase
			if card.currentPosition == card.position.IN_HAND and GmManager.currentPhase == GMManager.phase.PLAY:
				card.summon_button.visible = true
				card.mana_button.visible = true
			
			if card.currentPosition == card.position.IN_SUMMON:
				#A card in SUMMON can ATTACK during the PLAY phase
				if GmManager.currentPhase == GmManager.phase.PLAY and !card.exhausted:
					if !GmManager.attacking:
						card.attack_button.visible = true
				#A card in SUMMON can be SUSTAINED in the REFRESH phase
				elif GmManager.currentPhase == GmManager.phase.REFRESH and !card.paid and currentTurn == 1:
					card.keep_button.visible = true
			#A card in MANA can be exhausted to increase available mana
			if card.currentPosition == card.position.IN_MANA and !card.exhausted:
				card.mana_button.visible = true
			
		#Block button is only shown when the AI is attacking the player
		else:
			if card.currentPosition == card.position.IN_SUMMON:
				if GmManager.currentPhase == GmManager.phase.PLAY and !card.exhausted:
					card.block_button.visible = true
					
		#If something happens to the card while it's inspected it should still be destroyed properly
		if card.currentPosition == card.position.IN_DECK:
			await card.destroy(3)


#Remove a card from the selection area and return it to the appropriate zone
func deselect():
	#Can't deselect if nothing is selected
	if inspection_area.get_child_count() == 0:
		return
	
	sfx_player.stream = CLICK_3
	sfx_player.play()
	var card = inspection_area.get_child(0)
	#Turn all the buttons off
	card.inspect_view.visible = false
	card.summon_button.visible = false
	card.attack_button.visible = false
	card.block_button.visible = false
	card.keep_button.visible = false
	card.mana_button.visible = false
	card.action_button.visible = false
	
	
	#If the card is exhausted put it back at the right scale
	if card.exhausted:
		card.card_back.scale.x = .5
		card.card_back.scale.y = .5
		card.card_front.scale.x = .5
		card.card_front.scale.y = .5
		card.card_art.scale.x = .5
		card.card_art.scale.y = .5
	
	#Get the cards current 
	match (card.currentPosition):
		#Return the card to the appropriate player's HAND
		card.position.IN_HAND:
			if card.cardOwner == 1:
				card.reparent(p_1_hand)
				p_1_hand.move_child(card, cardIndex)
			else:
				card.reparent(p_2_hand)
				p_2_hand.move_child(card, cardIndex)
		#Return the card to the appropriate player's MANA
		card.position.IN_MANA:
			if card.cardOwner == 1:
				card.reparent(p_1_mana_zone)
				p_1_mana_zone.move_child(card, cardIndex)
				#If the player's card wasn't revealed put it back face down
				if not card.revealed:
					card.card_back.visible = true
					card.card_front.visible = false
					card.card_art.visible = false
			else:
				card.reparent(p_2_mana_zone)
		#Return the card to the appropriate player's SUMMON
		card.position.IN_SUMMON:
			if card.cardOwner == 1:
				card.reparent(p_1_summon_zone)
				p_1_summon_zone.move_child(card, cardIndex)
			else:
				card.reparent(p_2_summon_zone)
				p_2_summon_zone.move_child(card, cardIndex)

#Move given card from HAND to MANA
func card_to_mana(card):
	card.currentPosition = Card.position.IN_MANA
	remove_from_x(card)
	if card.cardOwner == 1:
		player1mana.push_front(card)
		card.reparent(p_1_mana_zone)
		card.inspect_view.visible = false
		card.summon_button.visible = false
		card.revealed = false
		
		totalMana += 1
	else:
		player2mana.push_front(card)
		card.reparent(p_2_mana_zone)
		card.inspect_view.visible = false
		card.revealed = false
		p2TotalMana += 1
	
#Move card from HAND to SUMMON
#TODO: Allow AI to use this method
func card_summon(card: Card) -> void:
	if card.cardOwner == 1:
		#if card.currentPosition != card.position.IN_HAND:
			#return
		if card.cost <= availableMana:
			availableMana -= card.cost
			move_to_summon(card)
	else:
		if card.cost <= p2AvailableMana:
			p2AvailableMana -= card.cost
			move_to_summon(card)

#Move card to summon zone regardless of previous position or mana
func move_to_summon(card: Card):
	match card.currentPosition:
		Card.position.IN_HAND:
			if card.cardOwner == 1:
				player1hand.erase(card)
			else:
				player2hand.erase(card)
		card.position.IN_DECK:
			if card.cardOwner == 1:
				player1deck.erase(card)
			else:
				player2deck.erase(card)
		card.position.IN_MANA:
			if card.cardOwner == 1:
				player1mana.erase(card)
			else:
				player2mana.erase(card)
		card.position.IN_SUMMON:
			return
	card.reveal()
	
	if card.cardOwner == 1:
		player1summon.push_front(card)
		card.reparent(p_1_summon_zone)
	else:
		player2summon.push_front(card)
		card.reparent(p_2_summon_zone)
	
	card.currentPosition  = card.position.IN_SUMMON
	card.summon_button.visible = false
	card.mana_button.visible = false
	card.inspect_view.visible = false
	card.refresh()
	
	card.resolve_summon()
	GmManager.emit_signal("_resolve_summon", card)
	
#Any card in SUMMON has to be paid for at the start of the turn
func card_keep(card: Card) -> void:
	if card.cardOwner == 1:
		if card.cost <= availableMana:
			availableMana -= card.cost
			card.paid = true
			card_select(card)
	else:
		if card.cost <= p2AvailableMana:
			p2AvailableMana -= card.cost
			card.paid = true
			#card_select(card)

func remove_from_x(card: Card):
	# remove it from whatever array it was in
	if card.cardOwner == 1:
		match card.currentPosition:
			Card.position.IN_SUMMON:
				player1summon.erase(card)
			Card.position.IN_MANA:
				player1mana.erase(card)
			Card.position.IN_HAND:
				player1hand.erase(card)
			Card.position.IN_DECK:
				player1deck.erase(card)
	else:
		match card.currentPosition:
			Card.position.IN_SUMMON:
				player2summon.erase(card)
			Card.position.IN_MANA:
				player2mana.erase(card)
			Card.position.IN_HAND:
				player2hand.erase(card)
			Card.position.IN_DECK:
				player2deck.erase(card)

#Removes the card from the field and puts it at the bottom of it's owner's deck
func move_to_deck(card: Card) -> void:
	#If it's already in the deck don't do anything
	if card.currentPosition == Card.position.IN_DECK:
		return
	
	#If it ends up above the deck for some reason, having the back viewed will just make it look like the deck
	card.card_front.visible = false
	card.card_back.visible = true
	card.inspect_view.visible = false
	card.refresh()
	
	
	remove_from_x(card)
	if card.cardOwner == 1:
		player1deck.push_back(card)
		card.reparent(p_1_deck)
	else:
		player2deck.push_back(card)
		card.reparent(p_2_deck)
	#Set the card's current location to be in the deck
	card.currentPosition = Card.position.IN_DECK
	card.hide()

#Moves the card from the field to it's owners hand
func move_to_hand(card: Card) -> void:
	
	card.refresh()
	if card.cardOwner == 1:
		if card.currentPosition == Card.position.IN_DECK:
			player1deck.erase(card)
		elif card.currentPosition == Card.position.IN_MANA:
			player1mana.erase(card)
		elif card.currentPosition == Card.position.IN_SUMMON:
			player1summon.erase(card)
		
		card.reveal()
		player1hand.push_back(card)
		card.reparent(p_1_hand)
	else:
		card.revealed = false
		card.card_front.visible = false
		card.card_back.visible = true
		card.card_art.visible = false
		
		if card.currentPosition == Card.position.IN_DECK:
			player2deck.erase(card)
		elif card.currentPosition == Card.position.IN_MANA:
			player2mana.erase(card)
		elif card.currentPosition == Card.position.IN_SUMMON:
			player2summon.erase(card)
			
		player2hand.push_back(card)
		card.reparent(p_2_hand)
	
	card.currentPosition = Card.position.IN_HAND

#Add to the card owner's available mana
func add_to_mana(card : Card, manaToAdd : int):
	if card.cardOwner == 1:
		availableMana += manaToAdd
	else:
		p2AvailableMana += manaToAdd

#Begin attacking. A card has to be chosen to block or the player has to pass
func card_attack(card : Card):
	#The player had to select the card to attack with it so deselect it
	deselect()
	
	
	#Store the attacking card so block() can reference it
	attackingCard = card
	GmManager.attacking = true
	
	check_interrupt()
	
	await GmManager._interrupt_empty
	if card.currentPosition != card.position.IN_SUMMON:
		GmManager.attacking = false
		return
		
	#If there are no card in the opposing player's SUMMON do direct damage
	if currentTurn == 1:
		if player2summon.size() == 0:
			
			GmManager.emit_signal("_card_exhaust", card)
			p2Health -= card.attack
			p_2_life.text = str(p2Health)
			
			GmManager.attacking = false
			if p2Health == 0:
				pass #TODO GAME VICTORY CODE HERE
			GmManager.emit_signal("_block_resolved")
			card.card_info_animation.visible = false
			return
		ai.choose_defense(card)
	if currentTurn == 2 and player1summon.size() == 0:
		GmManager.emit_signal("_card_exhaust", card)
		
		health -= card.attack
		p_1_life.text = str(health)
		GmManager.attacking = false
		if health == 0:
			pass #TODO GAME OVER CODE HERE
		card.card_info_animation.visible = false
		GmManager.emit_signal("_block_resolved")

#Apply direct damage to the given player
#May want to have card_attack() use this but it works as is
func direct_damage(damage: int, player: int):
	if player == 1:
		health -= damage
	else:
		p2Health -= damage

#A response to being attacked. Destroy any card involved that takes more damage than it has health
func card_block(card : Card):
	attackingCard.exhaust(attackingCard)
	deselect()
	if (attackingCard.attack > card.health):
		card.card_info_animation.play("DefenseFail")
		await card.card_info_animation.animation_finished
		card.card_info_animation.visible = false
		await card.destroy(1)
	if (card.attack > attackingCard.health):
		attackingCard.card_info_animation.play("AttackFail")
		await attackingCard.card_info_animation.animation_finished
		attackingCard.card_info_animation.visible = false
		await attackingCard.destroy(1)
	
	attackingCard.card_info_animation.visible = false
	card.card_info_animation.visible = false
	GmManager.attacking = false
	GmManager.emit_signal("_block_resolved")


#End the current turn and refreshes the currentTurn's player's cards
#Also activates the AI's turn. This may change
func change_turn():
	
	currentTurn = -currentTurn + 3
	GmManager.currentTurn = currentTurn
	
	#print (bool(currentTurn-2))
	GmManager.currentPhase = GmManager.phase.REFRESH
	phase_change_animation.visible = true
	phase_change_animation.play("SustainNotice")
	await phase_change_animation.animation_finished
	phase_change_animation.visible = false
	match currentTurn:
		1:
			ai.players_turn = true
			draw(1)
			for card in player1mana:
				card.refresh()
			for card in player1summon:
				card.refresh()
			
		2: 
			draw(2)
			for card in player2mana:
				card.refresh()
			for card in player2summon:
				card.refresh()
			ai.players_turn = false

#Changes from REFRESH to PLAY and destroys any unpaid cards
func change_phase():
	
	if currentTurn == 1:
		var i = 0
		while i < (player1summon.size()):
			if !player1summon[i].paid:
				await player1summon[i].destroy(3)
				i -= 1
			i += 1
	else:
		var i = 0
		while i < (player2summon.size()):
			if !player2summon[i].paid:
				await player2summon[i].destroy(3)
				i -= 1
			i += 1
			
	phase_change_animation.visible = true
	phase_change_animation.play("PlayNotice")
	await phase_change_animation.animation_finished
	phase_change_animation.visible = false
	
	GmManager.currentPhase = GmManager.phase.PLAY
	#if currentTurn == 2:
	#	ai.ai_play()

#	0 player1deck, 
#	1 player1hand, 
#	2 player1summon, 
#	3 player1mana,
#	4 player2deck, 
#	5 player2hand, 
#	6 player2summon, 
#	7 player2mana
func requestField(card: Card):
	card.use_field(field)

#NOTICE: zoneToSearch positions in field to search
#	0 player1deck, 
#	1 player1hand, 
#	2 player1summon, 
#	3 player1mana,
#	4 player2deck, 
#	5 player2hand, 
#	6 player2summon, 
#	7 player2mana
func offer_selection(triggerCard: Card, zonesToSearch: Array[int], matchConditions: Dictionary):
	var selectionChoices : Array[Card] = []
	for area in zonesToSearch:
		selectionChoices += field[area].filter(func(card: Card):
			for condition in matchConditions.keys():
				match condition:
					"target self":
						if !matchConditions["target self"] and triggerCard == card:
							return false
					"health" :
						if card.health > matchConditions["health"]:
							return false
					"cost" :
						if card.cost > matchConditions["cost"]:
							return false
					"revealed":
						if matchConditions["revealed"] != card.revealed:
							return false
					"exhausted":
						if matchConditions["exhausted"] != card.exhausted:
							return false
					"name":
						if matchConditions["name"][0] == "exclude":
							if matchConditions["name"][1] == card.cardName:
								print(card.cardName)
								return false
					"tags":
						for tag in matchConditions["tags"]:
							if !(tag in card.tags):
								return false
			return true
			)
	
	if selectionChoices.is_empty():
		triggerCard.effectOtherCard(null)
		return

	var chosenCard : Card
	if triggerCard.cardOwner == 1:
		chosenCard = await playerListSelection(selectionChoices)
	else:
		chosenCard = ai.choose_card(selectionChoices)
	
	triggerCard.effectOtherCard(chosenCard)

func playerListSelection(list : Array[Card]) -> Card:
	for card in list:
		if card.tags[0] == "Creature":
			selection_list.add_item(card.cardName, SUMMON_BUTTON)
		else:
			selection_list.add_item(card.cardName, CAST_BUTTON)
	selection_list_area.visible = true
	
	var num = await choice_made
	
	selection_list.clear()
	selection_list_area.visible = false
	
	return list[num]

#TODO: Add interrupts so cards that work off reactions can be played
func interrupt(card : Card):
	"""
	Present interrupt options
	IF interruptButtonPressed
	SELECT VALID CARD TO INTERRUPT
	IF passButtonPressed
	PROCEED WITH TURN
	"""
	interruptStack.push_back(card)
	GmManager.currentPhase = GmManager.phase.INTERRUPT
	if (card.cardOwner == 1):
		
		print("Interrupt added")
		interrupt_choice.show()
	else:
		ai.handle_interrupt(card)
	
func check_interrupt():
	var count := 0
	while count < len(interruptStack):
		var card := interruptStack[count]
		if card.resolved:
			interruptStack.erase(card)
			count -= 1
			
		count += 1
	
	if interruptStack.is_empty():
		GmManager.emit_signal("_interrupt_empty")
		GmManager.currentPhase = GmManager.phase.PLAY
		#GmManager.emit_signal("_interrupt_resolved")
		return
	
	
#Draw test card. This will be disable eventually
func _on_p_1_deck_pressed() -> void:
	var drawnCard = Card.constructor()
	drawnCard.currentPosition = Card.position.IN_HAND
	player1hand.push_front(drawnCard)
	p_1_hand.add_child(drawnCard)


func _on_node_2d_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.

#Changes phase and turn. OR if blocking allows damage to be dealt directly instead
func _on_pass_button_pressed() -> void:
	if GmManager.currentPhase == GmManager.phase.REFRESH:
		change_phase()
	elif GmManager.currentPhase == GmManager.phase.PLAY:
		if (GmManager.attacking):
			GmManager.attacking = false
			direct_damage(attackingCard.attack, 1)
			GmManager.emit_signal("_block_resolved")
		else:
			change_turn()

#Unused buttons for interrupts... For now
func _on_interrupt_button_pressed() -> void:
	interrupt_choice.hide()

#NOTICE: Assumes no interrupts happen in the SUSTAIN phase
func _on_interrupt_pass_button_pressed() -> void:
	for card: Card in interruptStack:
		card.action_button.visible = false
	interruptStack.clear()
	GmManager.currentPhase = GmManager.phase.PLAY
	GmManager.emit_signal("_interrupt_resolved")
	interrupt_choice.hide()


func _on_selection_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != 1:
		return
	
	emit_signal("choice_made", index)
