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
	cardName = "Spellweaver Pheonix"
	tags[1] = "Familiar"
	cardDescription = "On Summon: You may search your deck for one spell, add it to your hand"
	cardLore = '"The feathers of a Spellweaver Pheonix are infused with potent magic, making them sought after by many a mage."'
	cost = 2
	health = 3
	attack = 3
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
