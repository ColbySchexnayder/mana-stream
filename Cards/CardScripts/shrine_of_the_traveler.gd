class_name ShrineOfTheTraveler extends SpellCard

const SHRINEOFTHETRAVELER = preload("res://Cards/PlayableCards/ShrineOfTheTraveler.tscn")
static func constructor():
	var obj = SHRINEOFTHETRAVELER.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info():
	cardName = tr("SHRINE_OF_THE_TRAVELER_NAME")#"Shrine of the Traveler"
	tags[0] = "Spell"
	tags[1] = tr("SHRINE_OF_THE_TRAVELER_TYPE")#"Boon"
	cardDescription = tr("SHRINE_OF_THE_TRAVELER_ABILITY")#"This card must be played face down in the Mana Zone. When a card leaves your field reveal this card and refresh one Mana other than Shrine of the Traveler."
	cardLore = tr("SHRINE_OF_THE_TRAVELER_LORE")#'"It is common for mages to give a bit of their magic to shrines on their journey. A token offering to those on long journeys."'
	cost = int(tr("SHRINE_OF_THE_TRAVELER_COST"))#0

func _process(delta: float) -> void:
	summon_button.hide()
