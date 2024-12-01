extends Control

@onready var card_loader: Control = $CardLoader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GmManager.Player1Deck.is_empty():
		var deckFile := FileAccess.open("res://Save/Deck.txt", FileAccess.READ)
		
		var cardFileName := ""
		var count := 0
		while true:
			cardFileName = deckFile.get_line()
			if cardFileName == "":
				break
			
			
			var card = ResourceLoader.load("res://Cards/PlayableCards/"+cardFileName+".tscn").instantiate()#load("res://Cards/PlayableCards/"+cardFileName+".tscn")
			GmManager.Player1Deck.push_back(card)
			
			card_loader.add_child(GmManager.Player1Deck.back())
			count += 1
		deckFile.close()

	for card in GmManager.Player1Deck:
		print(card.cardName + "\n")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_deck_edit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DeckEdit.tscn")
