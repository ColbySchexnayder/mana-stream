class_name Veterinarian extends SpellCard

const VETERINARIAN = preload("res://Cards/PlayableCards/Veterinarian.tscn")
static func constructor():
	var obj = VETERINARIAN.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()
	GmManager.connect("_card_destroy", react)

func set_card_info():
	cardName = tr("VETERINARIAN_NAME")#"Veterinarian the Fantastic"
	tags[0] = "Spell"
	tags[1] = tr("VETERINARIAN_TYPE")#"Totemism"
	cardDescription = tr("VETERINARIAN_ABILITY")#"This card must be played face down in the Mana Zone. After a Familiar you control with a cost of 2 or more is destroyed you may reveal this card, shuffle your deck then draw 2 cards, then destroy this card"
	cardLore = tr("VETERINARIAN_LORE")#'"Most familiars can be returned to the Mana Stream and recalled nice and healthy. Not all familiars are so lucky."'
	cost = int(tr("VETERINARIAN_COST"))#0

func _process(_delta: float) -> void:
	summon_button.hide()

func react(card: Card):
	if revealed:
		return
	if currentPosition != Card.position.IN_MANA:
		return
	if card.cardOwner != cardOwner:
		return
	if !(tags[1] in card.tags):
		return
	if card.cost < 2:
		return
	
	GmManager.emit_signal("_interrupt", self)

func action():
	reveal()
	GmManager.emit_signal("_shuffle", cardOwner)
	GmManager.emit_signal("_draw", cardOwner)
	GmManager.emit_signal("_draw", cardOwner)
	
	await destroy(0)
	resolved = true
	GmManager.emit_signal("_interrupt_resolved")
