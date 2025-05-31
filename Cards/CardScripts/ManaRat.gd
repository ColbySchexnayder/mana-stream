class_name ManaRat extends Card


const MANARAT = preload("res://Cards/PlayableCards/ManaRat.tscn")
static func constructor():
	var obj = MANARAT.instantiate()
	return obj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	
	super._ready()

func set_card_info()->void:
	cardName = tr("MANA_RAT_NAME")#"Mana Rat"
	tags[1] = tr("MANA_RAT_TYPE")#"Familiar"
	cardDescription = tr("MANA_RAT_ABILITY")#"On Summon: You may search your deck for one familiar with a cost of 2 or less, add it to your hand"
	cardLore = tr("MANA_RAT_LORE")#'"The mana rat makes its burrows in the mana stream itself making them useful for guiding it along a mage\'s whims"'
	cost = int(tr("MANA_RAT_COST"))#1
	health = int(tr("MANA_RAT_HEALTH"))#1
	attack = int(tr("MANA_RAT_ATTACK"))#1

#TODO IMPLEMENT Search system
func summon()->void:
	pass
	
