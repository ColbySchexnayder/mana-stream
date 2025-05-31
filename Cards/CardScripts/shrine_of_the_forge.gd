class_name ShrineOfTheForge extends SpellCard

const SHRINEOFTHEFORGE = preload("res://Cards/PlayableCards/ShrineOfTheForge.tscn")
static func constructor():
	var obj = SHRINEOFTHEFORGE.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info():
	cardName = tr("SHRINE_OF_THE_FORGE_NAME")#"Shrine of the Forge"
	tags[0] = "Spell"
	tags[1] = tr("SHRINE_OF_THE_FORGE_NAME")#"Boon"
	cardDescription = tr("SHRINE_OF_THE_FORGE_ABILITY")#"This card must be played face down in the Mana Zone. When a card enters your field reveal this card and refresh one Mana other than Shrine of the Forge"
	cardLore = tr("SHRINE_OF_THE_FORGE_LORE")#'"Powerful mages passively release magic all around them. Even the simplest of items they make has ambient magic. Work they pour themselves into can turn even the are they work in to magic"'
	cost = int(tr("SHRINE_OF_THE_FORGE_COST"))#0

func _process(delta: float) -> void:
	summon_button.hide()
