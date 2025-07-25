class_name AI_Manager extends Node

var ai_hand := []
var ai_mana_zone := []
var ai_summon_zone := []
var ai_deck := []

var player_hand := []
var player_mana_zone := []
var player_summon_zone := []
var player_deck := []

var interruptStack : Array[Card] = []

var players_turn = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#GmManager.connect("_ai_turn", ai_turn)
	GmManager.connect("_interrupt", handle_interrupt)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#TODO: This all needs to be changed!
#TODO: Seriously don't ignore this

func ai_sustain():
	if !ai_summon_zone.is_empty():
		ai_hand[0].mana()
		ai_mana_zone[0].mana()
		GmManager.emit_signal("_card_keep", ai_summon_zone[0])
		
	GmManager.emit_signal("_change_phase")

func ai_play():
	if !ai_summon_zone.is_empty():
		ai_summon_zone[0].attacking()
		while !interruptStack.is_empty():
			await GmManager._interrupt_resolved
		
		await GmManager._block_resolved
		
	GmManager.emit_signal("_change_turn")

func choose_defense(card: Card):
	if players_turn:
		if ai_summon_zone.size() > 0:
			ai_summon_zone[0].block()
		else:
			GmManager.emit_signal("_pass")

func choose_card(list: Array[Card]) -> Card:
	return list[0]

func handle_interrupt(card: Card):
	if card.cardOwner == 1:
		return
