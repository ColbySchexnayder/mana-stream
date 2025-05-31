extends Control

@onready var card_loader: Control = $CardLoader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GmManager.Player1Deck.is_empty():
		GmManager.Player1Deck = GmManager.load_deck("Deck.txt")
	
	TranslationServer.set_locale("en")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_deck_edit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DeckEdit.tscn")


func _on_continue_button_pressed() -> void:
	pass # Replace with function body.


func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Duel.tscn")
