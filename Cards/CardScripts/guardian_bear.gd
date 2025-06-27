class_name GuardianBear extends Card


const GUARDIANBEAR = preload("res://Cards/PlayableCards/GuardianBear.tscn")
static func constructor():
	var obj = GUARDIANBEAR.instantiate()
	return obj
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func _process(_delta: float) -> void:
	GmManager.emit_signal("_request_field", self)
	cost_text.text = str(cost)

#	0 player1deck, 
#	1 player1hand, 
#	2 player1summon, 
#	3 player1mana,
#	4 player2deck, 
#	5 player2hand, 
#	6 player2summon, 
#	7 player2mana
func use_field(field):
	var costDiscount := 0
	var list : Array[Card] = []
	if cardOwner == 1:
		list = field[2]
	else:
		list = field[6]
	
	list = list.filter(func(c):return "Creature" in c.tags)
	
	cost = max(0,baseCost-list.size())

func set_card_info()->void:
	cardName = tr("GUARDIAN_BEAR_NAME")#"Guardian Bear"
	tags[1] = tr("GUARDIAN_BEAR_TYPE")#"Familiar"
	cardDescription = tr("GUARDIAN_BEAR_ABILITY")#"Reduce the cost of this card by 1 for each Familiar on the field"
	cardLore = tr("GUARDIAN_BEAR_LORE")#'"A beast known for it\'s undying loyalty to those who prove themselves"'
	cost = int(tr("GUARDIAN_BEAR_COST"))#4
	health = int(tr("GUARDIAN_BEAR_HEALTH"))#4
	attack = int(tr("GUARDIAN_BEAR_ATTACK"))#4
