class_name ShrineOfTheTraveler extends SpellCard

const SHRINEOFTHETRAVELER = preload("res://Cards/PlayableCards/ShrineOfTheTraveler.tscn")
static func constructor():
	var obj = SHRINEOFTHETRAVELER.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()
	
	GmManager.connect("_card_destroy", react)
	GmManager.connect("_move_to_hand", react)

func set_card_info():
	cardName = tr("SHRINE_OF_THE_TRAVELER_NAME")#"Shrine of the Traveler"
	tags[0] = "Spell"
	tags[1] = tr("SHRINE_OF_THE_TRAVELER_TYPE")#"Boon"
	cardDescription = tr("SHRINE_OF_THE_TRAVELER_ABILITY")#"This card must be played face down in the Mana Zone. When a card leaves your field reveal this card and refresh one Mana other than Shrine of the Traveler."
	cardLore = tr("SHRINE_OF_THE_TRAVELER_LORE")#'"It is common for mages to give a bit of their magic to shrines on their journey. A token offering to those on long journeys."'
	cost = int(tr("SHRINE_OF_THE_TRAVELER_COST"))#0
	
	resourceGatheringVal = 1
	actionBenefit = 1
	onlyWorksInMana = true

func _process(_delta: float) -> void:
	summon_button.hide()

func react(card: Card):
	if card.currentPosition == card.position.IN_DECK:
		return
	if !revealed and currentPosition == Card.position.IN_MANA:
		if card.cardOwner == cardOwner:
			GmManager.emit_signal("_interrupt", self)

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
