extends Card


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cardName = "Mana Rat"
	tags[1] = "Familiar"
	cardDescription = "On Summon: You may search your deck for one familiar with a cost of 2 or less, add it to your hand"
	cardLore = '"The mana rat makes its burrows in the mana stream itself making them useful for guiding it along a mage\'s whims"'
	cost = 1
	health = 1
	attack = 1
	
	name_text.text = cardName
	attack_text.text = str(attack)
	health_text.text = str(health)
	cost_text.text = str(cost)
	tag_text.text = tags[0] + ", " + tags[1]
	description_text.text = cardDescription

#TODO IMPLEMENT Search system
func summon():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
