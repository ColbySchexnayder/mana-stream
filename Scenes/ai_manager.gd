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
	GmManager.connect("_choose_defense", choose_defense)
	GmManager.connect("_ai_turn", ai_turn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ai_turn():
	pass
	
func choose_defense(card):
	if players_turn:
		if ai_summon_zone.size() > 0:
			var blocker = ai_summon_zone[0]
			GmManager.emit_signal("_card_block", blocker)
		else:
			GmManager.emit_signal("_pass")
