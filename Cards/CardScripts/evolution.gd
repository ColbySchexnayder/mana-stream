class_name Evolution extends SpellCard

const EVOLUTION = preload("res://Cards/PlayableCards/ManaRat.tscn")
static func constructor():
	var obj = EVOLUTION.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info():
	cardName = "Evolution"
	tags[1] = "Totemism"
	cardDescription = "Select one face down Creature from the Mana Zone, place it face up in the Summon Zone"
	cardLore = '"The guiding hand of an expert mage can bring out the best in their familiars"'
	cost = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
