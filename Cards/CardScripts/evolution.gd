class_name Evolution extends SpellCard

const EVOLUTION = preload("res://Cards/PlayableCards/Evolution.tscn")
static func constructor():
	var obj = EVOLUTION.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info()->void:
	cardName = tr("EVOLUTION_NAME")#"Evolution"
	tags[0] = "Spell"
	tags[1] = tr("EVOLUTION_TYPE")#Formerly "Totemism", now familiar to match creature types
	cardDescription = tr("EVOLUTION_ABILITY")#"Select one face down Creature from the Mana Zone, place it face up in the Summon Zone"
	cardLore = tr("EVOLUTION_LORE")#'"The guiding hand of an expert mage can bring out the best in their familiars"'
	cost = int(tr("EVOLUTION_COST"))#1


#	0 player1deck, 
#	1 player1hand, 
#	2 player1summon, 
#	3 player1mana,
#	4 player2deck, 
#	5 player2hand, 
#	6 player2summon, 
#	7 player2mana
func resolve_summon():
	
	var conditions = {"tags" : ["Creature"], "revealed" : false}
	var zones : Array[int]
	if cardOwner == 1:
		zones = [3]
	else:
		zones = [7]
	GmManager.emit_signal("_offer_selection", self, zones, conditions)
	
	super.resolve_summon()

func effectOtherCard(card: Card):
	GmManager.emit_signal("_move_to_summon", card)
