class_name AI_Manager extends Node

var ai_hand := []
var ai_mana_zone := []
var ai_summon_zone := []
var ai_deck := []

var player_hand := []
var player_mana_zone := []
var player_summon_zone := []
var player_deck := []

var players_turn = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GmManager.connect("_ai_turn", ai_turn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#TODO: This all needs to be changed!
#TODO: Seriously don't ignore this
func ai_turn():
	if GmManager.currentPhase == GmManager.phase.REFRESH:
		if !ai_summon_zone.is_empty():
			ai_hand[0].mana()
			ai_mana_zone[0].mana()
			await GmManager.emit_signal("_card_keep", ai_summon_zone[0])
		GmManager.emit_signal("_change_phase")
	if GmManager.currentPhase == GmManager.phase.PLAY:
		if !ai_summon_zone.is_empty():
			GmManager.emit_signal("_card_attack", ai_summon_zone[0])
			if !player_summon_zone.is_empty():
				await GmManager._block_resolved
		GmManager.emit_signal("_change_turn")
	
func choose_defense(card):
	if players_turn:
		if ai_summon_zone.size() > 0:
			ai_summon_zone[0].block()
		else:
			GmManager.emit_signal("_pass")
