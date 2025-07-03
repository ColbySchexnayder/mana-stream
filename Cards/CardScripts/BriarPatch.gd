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
	


func set_card_info()->void:
	cardName = tr("BRIARPATCH_NAME")
	tags[0] = "Spell"
	tags[1] = tr("BRIARPATCH_TYPE")
	cardDescription = tr("BRIARPATCH_ABILITY")#"This card must be played face down in the Mana Zone. When your opponent attacks reveal this card and send one card you control back to your hand, then destroy this card."
	cardLore = tr("BRIARPATCH_LORE")#'"Once upon a time there was a hungry fox and a clever rabbit."'
	cost = int(tr("BRIARPATCH_COST"))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	summon_button.hide()

func card_attacks(card: Card):
	#only deal with player1 interrupts for now
	if !revealed and currentPosition == Card.position.IN_MANA:
		if card.cardOwner != cardOwner:
			GmManager.emit_signal("_interrupt", self)
			attackingCard = card

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
	attackingCard.exhaust(attackingCard)
	attackingCard.card_info_animation.visible = false
	
	var conditions = {"target self" : false}
	var zones : Array[int]= []
	
	if cardOwner == 1:
		zones = [2,3]
	else:
		zones = [6,7]
	
	GmManager.attacking = false
	GmManager.emit_signal("_offer_selection", self, zones, conditions)
	
	

func effectOtherCard(card: Card):
	if card != null:
		GmManager.emit_signal("_move_to_hand", card)
	await destroy(0)
	GmManager.emit_signal("_interrupt_resolved")
	resolved = true

func resolve_summon():
	super.resolve_summon()
