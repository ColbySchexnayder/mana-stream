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

func resolve_summon():
	
	print("Prepping Evolution")
	var conditions = {"tags" : ["Creature"], "revealed" : false}
	var zones : Array[int] = [3]
	GmManager.emit_signal("_offer_selection", self, zones, conditions)
	#TODO: Use ItemList to present acceptable cards to move to SUMMON ZONE
	super.resolve_summon()

func effectOtherCard(card: Card):
	GmManager.emit_signal("_move_to_summon", card)
