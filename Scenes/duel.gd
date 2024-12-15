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
var attacking := false
var attackingCard

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

@onready var ai: AI_Manager = $AI
#endregion

# Prepare the duel
func _ready() -> void:
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
	player1deck.shuffle()
	player2deck.shuffle()
	
	#Draw the starting hand
	for i in range(5):
		draw(1)
		draw(2)
	
	#region Add Test Cards
	var testSpell = Briarpatch.constructor()
	testSpell.currentPosition = Card.position.IN_HAND
	player1hand.push_front(testSpell)
	p_1_hand.add_child(testSpell)

	testSpell = SpellCard.constructor()
	testSpell.currentPosition = Card.position.IN_HAND
	player1hand.push_front(testSpell)
	p_1_hand.add_child(testSpell)
	
	
	var opponentsDefense = Card.constructor()
	opponentsDefense.cardOwner = 2
	opponentsDefense.currentPosition = Card.position.IN_SUMMON
	p_2_summon_zone.add_child(opponentsDefense)
	player2summon.push_front(opponentsDefense)
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
	
	#Initialize signals
	GmManager.connect("_card_select", card_select)
	GmManager.connect("_card_to_mana", card_to_mana)
	GmManager.connect("_card_summon", card_summon)
	GmManager.connect("_add_to_mana", add_to_mana)
	GmManager.connect("_card_attack", card_attack)
	GmManager.connect("_move_to_deck", move_to_deck)
	GmManager.connect("_card_block", card_block)
	GmManager.connect("_interrupt", interrupt)
	GmManager.connect("_card_keep", card_keep)
	GmManager.connect("_change_turn", change_turn)
	GmManager.connect("_change_phase", change_phase)
	
	#Give AI mana for testing
	#Needs to be done after signals are connected otherwise "card_to_mana" won't work
	player2hand[0].mana()
	

# Keep the text up to date and cards organized
func _process(delta: float) -> void:
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

#Move given card from HAND to MANA
func card_to_mana(card):
	if card.cardOwner == 1:
		player1mana.push_front(card)
		player1hand.erase(card)
		card.reparent(p_1_mana_zone)
		card.inspect_view.visible = false
		card.summon_button.visible = false
		card.revealed = false
		
		totalMana += 1
	else:
		player2mana.push_front(card)
		player2hand.erase(card)
		card.reparent(p_2_mana_zone)
		card.inspect_view.visible = false
		card.revealed = false
		p2TotalMana += 1
	

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
	if inspection_area.get_child_count() == 0:
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
			if currentTurn == 1:
				#A card in the hand can be sent to MANA or SUMMON in the PLAY phase
				if card.currentPosition == card.position.IN_HAND and GmManager.currentPhase == GMManager.phase.PLAY:
					card.summon_button.visible = true
					card.mana_button.visible = true
				
				if card.currentPosition == card.position.IN_SUMMON:
					#A card in SUMMON can ATTACK during the PLAY phase
					if GmManager.currentPhase == GmManager.phase.PLAY and !card.exhausted:
						if !attacking:
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
			#I think this is unnessecary but it's here as a safety net
			if card.currentPosition == card.position.IN_DECK:
				card.destroy(card)
	#If the player selects the card again unselect it
	elif inspection_area.get_child(0) == card:
		deselect()

#Remove a card from the selection area and return it to the appropriate zone
func deselect():
	#Can't deselect if nothing is selected
	if inspection_area.get_child_count() == 0:
		return
	
	var card = inspection_area.get_child(0)
	#Turn all the buttons off
	card.inspect_view.visible = false
	card.summon_button.visible = false
	card.attack_button.visible = false
	card.block_button.visible = false
	card.keep_button.visible = false
	card.mana_button.visible = false
	
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

#Move card from HAND to SUMMON
#TODO: Allow AI to use this method
func card_summon(card: Card) -> void:
	if card.currentPosition != card.position.IN_HAND:
		return
	if card.cost <= availableMana:
		availableMana -= card.cost
		player1summon.push_front(card)
		player1hand.erase(card)
		card.reparent(p_1_summon_zone)
		card.currentPosition  = card.position.IN_SUMMON
		card.summon_button.visible = false
		card.mana_button.visible = false
		card.inspect_view.visible = false
		interruptStack.push_back(card)
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
			card_select(card)

#Removes the card from the field and puts it at the bottom of it's owner's deck
func move_to_deck(card: Card) -> void:
	#If it's already in the deck don't do anything
	if card.currentPosition == Card.position.IN_DECK:
		return
	
	#If it ends up above the deck for some reason, having the back viewed will just make it look like the deck
	card.card_front.visible = false
	card.card_back.visible = true
	card.inspect_view.visible = false
	
	#Put the card at the bottom of the deck and remove it from whatever array it was in
	if card.cardOwner == 1:
		player1deck.push_back(card)
		card.reparent(p_1_deck)
		match card.currentPosition:
			card.position.IN_SUMMON:
				player1summon.erase(card)
			card.position.IN_MANA:
				player1mana.erase(card)
			card.position.IN_HAND:
				player1hand.erase(card)
	else:
		player2deck.push_back(card)
		card.reparent(p_2_deck)
		match card.currentPosition:
			card.position.IN_SUMMON:
				player2summon.erase(card)
			card.position.IN_MANA:
				player2mana.erase(card)
			card.position.IN_HAND:
				player2hand.erase(card)
	
	#Set the card's current location to be in the deck
	card.currentPosition = Card.position.IN_DECK
	card.hide()

#Add to the card owner's available mana
func add_to_mana(card, manaToAdd):
	if card.cardOwner == 1:
		availableMana += manaToAdd
	else:
		p2AvailableMana += manaToAdd

#Begin attacking. A card has to be chosen to block or the player has to pass
func card_attack(card):
	#The player had to select the card to attack with it so deselect it
	deselect()
	
	#Store the attacking card so block() can reference it
	attackingCard = card
	attacking = true
	
	#If there are no card in the opposing player's SUMMON do direct damage
	if currentTurn == 1:
		if player2summon.size() == 0:
			
			GmManager.emit_signal("_card_exhaust", card)
			p2Health -= card.attack
			p_2_life.text = str(p2Health)
			
			attacking = false
			if p2Health == 0:
				pass #TODO GAME VICTORY CODE HERE
			GmManager.emit_signal("_block_resolved")
			return
		ai.choose_defense(card)
	if currentTurn == 2 and player1summon.size() == 0:
		GmManager.emit_signal("_card_exhaust", card)
		
		health -= card.attack
		p_1_life.text = str(health)
		attacking = false
		if health == 0:
			pass #TODO GAME OVER CODE HERE
		GmManager.emit_signal("_block_resolved")
		return

#Apply direct damage to the given player
#May want to have card_attack() use this but it works as is
func direct_damage(damage: int, player: int):
	if player == 1:
		health -= damage
	else:
		p2Health -= damage

#A response to being attacked. Destroy any card involved that takes more damage than it has health
func card_block(card):
	deselect()
	attackingCard.exhaust(attackingCard)
	if (attackingCard.attack > card.health):
		card.destroy(1)
	if (card.attack > attackingCard.health):
		attackingCard.destroy(1)
	attacking = false
	
	GmManager.emit_signal("_block_resolved")
	
#End the current turn and refreshes the currentTurn's player's cards
#Also activates the AI's turn. This may change
func change_turn():
	
	currentTurn = -currentTurn + 3
	GmManager.currentTurn = currentTurn
	
	#print (bool(currentTurn-2))
	GmManager.currentPhase = GmManager.phase.REFRESH
	
	match currentTurn:
		1:
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
			ai.ai_turn()

#Changes from REFRESH to PLAY and destroys any unpaid cards
func change_phase():
	if currentTurn == 1:
		var i = 0
		while i < (player1summon.size()):
			if !player1summon[i].paid:
				player1summon[i].destroy(3)
				i -= 1
			i += 1
	else:
		var i = 0
		while i < (player2summon.size()):
			if !player2summon[i].paid:
				player2summon[i].destroy(3)
				i -= 1
			i += 1
	GmManager.currentPhase = GmManager.phase.PLAY

#TODO: Add interrupts so cards that work off reactions can be played
func interrupt(card):
	"""
	Present interrupt options
	IF interruptButtonPressed
	SELECT VALID CARD TO INTERRUPT
	IF passButtonPressed
	PROCEED WITH TURN
	"""
	interrupt_choice.show()
	
	pass

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
		if (attacking):
			attacking = false
			direct_damage(attackingCard.attack, 1)
			GmManager.emit_signal("_block_resolved")
		else:
			change_turn()

#Unused buttons for interrupts... For now
func _on_interrupt_button_pressed() -> void:
	interrupt_choice.hide()


func _on_interrupt_pass_button_pressed() -> void:
	interrupt_choice.hide()
