class_name ManaRat extends Card


const MANARAT = preload("res://Cards/PlayableCards/ManaRat.tscn")
static func constructor():
	var obj = MANARAT.instantiate()
	return obj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	
	super._ready()

func set_card_info():
	cardName = "Mana Rat"
	tags[1] = "Familiar"
	cardDescription = "On Summon: You may search your deck for one familiar with a cost of 2 or less, add it to your hand"
	cardLore = '"The mana rat makes its burrows in the mana stream itself making them useful for guiding it along a mage\'s whims"'
	cost = 1
	health = 1
	attack = 1

#TODO IMPLEMENT Search system
func summon():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
