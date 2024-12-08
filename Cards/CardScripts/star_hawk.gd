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
	cardName = "Star Hawk"
	tags[1] = "Familiar"
	cardDescription = "This card cannot be destroyed by battle"
	cardLore = '"Born of the Mana Stream itself, a fully grown Star Hawk can envelop whole cities in night as it flies overhead."'
	cost = 4
	health = 5
	attack = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func destroy(cause: int) -> void:
	if cause == 1:
		return
	
	super.destroy(cause)
