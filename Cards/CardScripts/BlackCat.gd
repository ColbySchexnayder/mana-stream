extends Card


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cardName = "Black Cat"
	tags[1] = "Familiar"
	cardDescription = ""
	cardLore = '"Black cats are known for bringing misfortune upon those whose path they cross but their intelligence and affinity for magic make them the most common familiar of witches"'
	cost = 1
	health = 2
	attack = 2
	
	name_text.text = cardName
	attack_text.text = str(attack)
	health_text.text = str(health)
	cost_text.text = str(cost)
	tag_text.text = tags[0] + ", " + tags[1]
	description_text.text = cardDescription


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
