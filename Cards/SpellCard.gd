class_name SpellCard extends Card

const SPELLCARD = preload("res://Cards/SpellCard.tscn")
static func constructor():
	var obj = SPELLCARD.instantiate()
	return obj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()
	#GmManager.connect("_resolve_summon", resolve_cast)

func set_card_info():
	cost = 0
	tags = ["Spell", "testbugspell"]
	cardName = "Spell Card Name That is Also Overlong"

func resolve_summon():
	
	if card.currentPosition == Card.position.IN_SUMMON:
		print('success')
		await destroy(0)
