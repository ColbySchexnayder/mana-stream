class_name SpellCard extends Card

const SPELLCARD = preload("res://Cards/SpellCard.tscn")
static func constructor():
	var obj = SPELLCARD.instantiate()
	return obj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost = 0
	tags = ["spell", "testbugspell"]
	cardName = "Spell Card Name That is Also Overlong"
	name_text.text = cardName
	tag_text.text = tags[0] + ", " + tags[1]
	cost_text.text = str(cost)
	GmManager.connect("_resolve_summon", resolve_cast)

func resolve_cast(card):
	await 1
	if card.currentPosition == Card.position.IN_SUMMON:
		print('success')
		destroy()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
