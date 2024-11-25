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
	cardName = "Shrine of the Traveler"
	tags[0] = "Spell"
	tags[1] = "Boon"
	cardDescription = "This card must be played face down in the Mana Zone. When a card leaves your field reveal this card and refresh one Mana other than Shrine of the Traveler."
	cardLore = '"It is common for mages to give a bit of their magic to shrines on their journey. A token offering to those on long journeys."'
	cost = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
