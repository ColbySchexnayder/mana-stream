class_name ShrineOfTheForge extends SpellCard

const SHRINEOFTHEFORGE = preload("res://Cards/PlayableCards/ShrineOfTheForge.tscn")
static func constructor():
	var obj = SHRINEOFTHEFORGE.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()
	
	GmManager.connect("_card_to_mana", react)
	GmManager.connect("_resolve_summon", react)

func set_card_info():
	cardName = tr("SHRINE_OF_THE_FORGE_NAME")#"Shrine of the Forge"
	tags[0] = "Spell"
	tags[1] = tr("SHRINE_OF_THE_FORGE_NAME")#"Boon"
	cardDescription = tr("SHRINE_OF_THE_FORGE_ABILITY")#"This card must be played face down in the Mana Zone. When a card enters your field reveal this card and refresh one Mana other than Shrine of the Forge"
	cardLore = tr("SHRINE_OF_THE_FORGE_LORE")#'"Powerful mages passively release magic all around them. Even the simplest of items they make has ambient magic. Work they pour themselves into can turn even the are they work in to magic"'
	cost = int(tr("SHRINE_OF_THE_FORGE_COST"))#0
	
	onlyWorksInMana = true

func _process(_delta: float) -> void:
	summon_button.hide()

func react(card: Card):
	if card == self:
		return
	#if card.currentPosition == Card.position.IN_MANA or card.currentPosition == Card.position.IN_SUMMON:
	#	return
	
	if !revealed and currentPosition == Card.position.IN_MANA:
		if card.cardOwner == cardOwner:
			GmManager.emit_signal("_interrupt", self)

#		FIELD
#	0 player1deck, 
#	1 player1hand, 
#	2 player1summon, 
#	3 player1mana,
#	4 player2deck, 
#	5 player2hand, 
#	6 player2summon, 
#	7 player2mana
func action():
	
	revealed = true
	
	var conditions = {"target self" : false, "exhausted" : true, "name" : ["exclude" , cardName]}
	var zones : Array[int]= []
	
	if cardOwner == 1:
		zones = [3]
	else:
		zones = [7]
	
	GmManager.emit_signal("_offer_selection", self, zones, conditions)

func effectOtherCard(card: Card):
	if card != null:
		card.refresh()
	
	GmManager.emit_signal("_interrupt_resolved")
	resolved = true
