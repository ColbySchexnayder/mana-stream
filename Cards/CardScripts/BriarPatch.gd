extends SpellCard


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cardName = "BriarPatch"
	tags[1] = "Fable"
	cardDescription = "This card must be played face down in the Mana Zone. When your opponent attacks reveal this card and send one card you control back to your hand, then destroy this card."
	cardLore = '"Once upon a time there was a hungry fox and a clever rabbit."'
	cost = 0
	
	name_text.text = cardName
	cost_text.text = str(cost)
	tag_text.text = tags[0] + ", " + tags[1]
	description_text.text = cardDescription


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
