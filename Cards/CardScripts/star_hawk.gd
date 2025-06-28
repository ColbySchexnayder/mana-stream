class_name StarHawk extends Card

const STARHAWK = preload("res://Cards/PlayableCards/StarHawk.tscn")
static func constructor():
	var obj = STARHAWK.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	
	super._ready()

func set_card_info():
	cardName = tr("STAR_HAWK_NAME")#"Star Hawk"
	tags[1] = tr("STAR_HAWK_TYPE")#"Familiar"
	cardDescription = tr("STAR_HAWK_ABILITY")#"This card cannot be destroyed by battle"
	cardLore = tr("STAR_HAWK_LORE")#'"Born of the Mana Stream itself, a fully grown Star Hawk can envelop whole cities in night as it flies overhead."'
	cost = int(tr("STAR_HAWK_COST"))#4
	health = int(tr("STAR_HAWK_HEALTH"))#5
	attack = int(tr("STAR_HAWK_ATTACK"))#5

#NOTICE Tentatively @cause. 0: Resolving card. 1: from battle. 2:from card effect. 3. Cost not paid more to be added?
func destroy(cause: int) -> void:
	if cause == 1:
		return
	
	super.destroy(cause)
