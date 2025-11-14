class_name SpellWeaverPheonix extends Card

const SPELLWEAVERPHEONIX = preload("res://Cards/PlayableCards/SpellWeaverPheonix.tscn")
static func constructor():
	var obj = SPELLWEAVERPHEONIX.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info():
	cardName = tr("SPELLWEAVER_PHOENIX_NAME")#"Spellweaver Pheonix"
	tags[1] = tr("SPELLWEAVER_PHOENIX_TYPE")#"Familiar"
	cardDescription = tr("SPELLWEAVER_PHOENIX_ABILITY")#"On Summon: You may search your deck for one spell, add it to your hand"
	cardLore = tr("SPELLWEAVER_PHOENIX_LORE")#'"The feathers of a Spellweaver Pheonix are infused with potent magic, making them sought after by many a mage."'
	cost = int(tr("SPELLWEAVER_PHOENIX_COST"))#2
	health = int(tr("SPELLWEAVER_PHOENIX_HEALTH"))#3
	attack = int(tr("SPELLWEAVER_PHOENIX_ATTACK"))#3

#	0 player1deck, 
#	1 player1hand, 
#	2 player1summon, 
#	3 player1mana,
#	4 player2deck, 
#	5 player2hand, 
#	6 player2summon, 
#	7 player2mana
func resolve_summon():
	GmManager.emit_signal("_interrupt", self)
	super.resolve_summon()
	
func action():
	await super.action()
	var conditions = {"tags" : ["Spell"]}
	var zones : Array[int]
	if cardOwner == 1:
		zones = [0]
	else:
		zones = [4]
	GmManager.emit_signal("_offer_selection", self, zones, conditions)
	
	

func effectOtherCard(card: Card):
	GmManager.emit_signal("_move_to_hand", card)
	resolved = true
	GmManager.emit_signal("_interrupt_resolved")
