class_name Briarpatch extends SpellCard


const BRIARPATCHCARD = preload("res://Cards/PlayableCards/Briarpatch.tscn")
static func constructor():
	var obj = BRIARPATCHCARD.instantiate()
	return obj
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# NEED THIS FOR OTHER CARDS super._ready()
	set_card_info()
	"""
	name_text.text = cardName
	cost_text.text = str(cost)
	tag_text.text = tags[0] + ", " + tags[1]
	description_text.text = cardDescription
	"""
	super._ready()
	GmManager.connect("_card_attack", card_attacks)

func set_card_info():
	cardName = "Briarpatch"
	tags[1] = "Fable"
	cardDescription = "This card must be played face down in the Mana Zone. When your opponent attacks reveal this card and send one card you control back to your hand, then destroy this card."
	cardLore = '"Once upon a time there was a hungry fox and a clever rabbit."'
	cost = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	summon_button.hide()

func card_attacks(card):
	if !revealed and currentPosition == Card.position.IN_MANA:
		if card.owner != owner:
			GmManager.emit_signal("_interrupt", self)

func pass_interrupt():
	pass
	
func complete_interrupt():
	pass

func resolve_cast(card):
	super.resolve_cast(card)
