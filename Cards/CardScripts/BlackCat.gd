class_name BlackCat extends Card

const BLACKCAT = preload("res://Cards/PlayableCards/BlackCat.tscn")
static func constructor():
	var obj = BLACKCAT.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info()->void:
	cardName = tr("BLACK_CAT_NAME")
	tags[1] = tr("BLACK_CAT_TYPE")
	cardDescription = ""
	cardLore = tr("BLACK_CAT_LORE")#'"Black cats are known for bringing misfortune upon those whose path they cross but their intelligence and affinity for magic make them the most common familiar of witches"'
	cost = int(tr("BLACK_CAT_COST"))#1
	health = int(tr("BLACK_CAT_HEALTH"))#2
	attack = int(tr("BLACK_CAT_ATTACK"))#2
	
