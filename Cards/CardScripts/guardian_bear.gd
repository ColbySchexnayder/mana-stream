class_name GuardianBear extends Card


const GUARDIANBEAR = preload("res://Cards/PlayableCards/GuardianBear.tscn")
static func constructor():
	var obj = GUARDIANBEAR.instantiate()
	return obj
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info():
	cardName = "Guardian Bear"
	tags[1] = "Familiar"
	cardDescription = "Reduce the cost of this card by 1 for each Familiar on the field"
	cardLore = '"A beast known for it\'s undying loyalty to those who prove themselves"'
	cost = 4
	health = 4
	attack = 4
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
