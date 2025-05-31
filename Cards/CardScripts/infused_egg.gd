class_name InfusedEgg extends SpellCard

const INFUSEDEGG = preload("res://Cards/PlayableCards/InfusedEgg.tscn")
static func constructor():
	var obj = INFUSEDEGG.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info() -> void:
	cardName = tr("INFUSED_EGG_NAME")#"Infused Egg"
	tags[0] = "Spell"
	tags[1] = tr("INFUSED_EGG_TYPE")#"Totemism"
	cardDescription = tr("INFUSED_EGG_ABILITY")#"Search your deck for 1 familiar, place it face down in your Mana Zone"
	cardLore = tr("INFUSED_EGG_LORE")#'"The egg of a being infused with the raw magic of the Mana Stream creates the most fantastic of creatures"'
	cost = int(tr("INFUSED_EGG_COST"))#2
