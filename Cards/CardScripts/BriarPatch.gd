class_name Briarpatch extends SpellCard


var attackingCard: Card

const BRIARPATCHCARD = preload("res://Cards/PlayableCards/Briarpatch.tscn")
static func constructor():
	var obj = BRIARPATCHCARD.instantiate()
	return obj
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# NEED THIS FOR OTHER CARDS super._ready()
	set_card_info()
	
	super._ready()
	GmManager.connect("_card_attack", card_attacks)

func set_card_info():
	cardName = "Briarpatch"
	tags[0] = "Spell"
	tags[1] = "Fable"
	cardDescription = "This card must be played face down in the Mana Zone. When your opponent attacks reveal this card and send one card you control back to your hand, then destroy this card."
	cardLore = '"Once upon a time there was a hungry fox and a clever rabbit."'
	cost = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	summon_button.hide()

func card_attacks(card):
	if !revealed and currentPosition == Card.position.IN_MANA:
		if card.cardOwner != cardOwner:
			GmManager.emit_signal("_interrupt", self)
			attackingCard = card
			
func action():
	GmManager.emit_signal("_move_to_hand", attackingCard)
	resolved = true
	

func resolve_summon():
	super.resolve_summon()
