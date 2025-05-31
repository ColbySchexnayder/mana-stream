class_name GuardianBear extends Card


const GUARDIANBEAR = preload("res://Cards/PlayableCards/GuardianBear.tscn")
static func constructor():
	var obj = GUARDIANBEAR.instantiate()
	return obj
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info()->void:
	cardName = tr("GUARDIAN_BEAR_NAME")#"Guardian Bear"
	tags[1] = tr("GUARDIAN_BEAR_TYPE")#"Familiar"
	cardDescription = tr("GUARDIAN_BEAR_ABILITY")#"Reduce the cost of this card by 1 for each Familiar on the field"
	cardLore = tr("GUARDIAN_BEAR_LORE")#'"A beast known for it\'s undying loyalty to those who prove themselves"'
	cost = int(tr("GUARDIAN_BEAR_COST"))#4
	health = int(tr("GUARDIAN_BEAR_HEALTH"))#4
	attack = int(tr("GUARDIAN_BEAR_ATTACK"))#4
