class_name BlackCat extends Card

const BLACKCAT = preload("res://Cards/PlayableCards/BlackCat.tscn")
static func constructor():
	var obj = BLACKCAT.instantiate()
	return obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_info()
	super._ready()

func set_card_info():
	cardName = "Black Cat"
	tags[1] = "Familiar"
	cardDescription = ""
	cardLore = '"Black cats are known for bringing misfortune upon those whose path they cross but their intelligence and affinity for magic make them the most common familiar of witches"'
	cost = 1
	health = 2
	attack = 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
