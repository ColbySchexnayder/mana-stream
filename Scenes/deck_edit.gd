extends Control

var cards = []
var cardNames = []
var deck = []

var selectedIndex = -1

@onready var card_list: ItemList = $TabContainer/CardList
@onready var deck_list: ItemList = $TabContainer/DeckList
@onready var cardsControl: Control = $Cards
@onready var card_limit_text: RichTextLabel = $TabContainer/DeckList/CardLimitText
@onready var inspect_view: CenterContainer = $InspectView
@onready var deck_cards: Control = $DeckCards

const CAST_BUTTON = preload("res://Art/castButton.png")
const SUMMON_BUTTON = preload("res://Art/summonButton.png")
const DECK_PATH = "res://Save/Deck.txt"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path := "res://Cards/PlayableCards/"
	var dir := DirAccess.open(path)
	var fileName := ""
	var count := 0
	
	dir.list_dir_begin()
	while true:
		fileName = dir.get_next()
		if fileName == "":
			break
		
		if !fileName.begins_with(".") and !fileName.ends_with(".import"):
			cardNames.push_back(fileName)
			cards.push_back(ResourceLoader.load(path+fileName).instantiate())
			
			cardsControl.add_child(cards[count])
			
			if cards[count].tags[0] == "Creature":
				card_list.add_item(cards[count].cardName, SUMMON_BUTTON)
			else:
				card_list.add_item(cards[count].cardName, CAST_BUTTON)
			print(cards[count].tags[0] +"\n" + cards[count].cardName + "\n\n")
			count+=1

	dir.list_dir_end()
	
	#var card = ResourceLoader.load("res://Cards/PlayableCards/"+cardFileName+".tscn").instantiate()#load("res://Cards/PlayableCards/"+cardFileName+".tscn")
	#GmManager.Player1Deck.push_back(card)
	for cardName in GmManager.Player1Deck:
		var card = ResourceLoader.load("res://Cards/PlayableCards/"+cardName+".tscn").instantiate()#load("res://Cards/PlayableCards/"+cardFileName+".tscn")
		deck_cards.add_child(card)
		deck.push_back(card)
		if card.tags[0] == "Creature":
			deck_list.add_item(card.cardName, SUMMON_BUTTON)
		else:
			deck_list.add_item(card.cardName, CAST_BUTTON)
	
	GmManager.connect("_card_add", add_card)
	GmManager.connect("_card_remove", remove_card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	card_limit_text.text = str(len(deck)) + "/30"


func _on_save_deck_button_pressed() -> void:
	if len(deck) != 30:
		print("Invalid deck")
		return
	
	
	var string = ""
	for card in deck:
		string += card.get_script().get_global_name() + "\n"
	var deckFile = FileAccess.open(DECK_PATH, FileAccess.WRITE)
	deckFile.store_string(string)
	deckFile.close()
	GmManager.Player1Deck = []
	
	get_tree().change_scene_to_file("res://Scenes/titleScreen.tscn")


func _on_card_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != 1:
		return
		
	selectedIndex = index
	var card = cards[index]
	
	for inspected in inspect_view.get_children():
		inspected.reparent(cardsControl)
		inspected.add_button.visible = false
		if card == inspected:
			return
	
	card.reparent(inspect_view)
	card.inspect_view.visible = true
	card.card_back.visible = false
	card.card_front.visible = true
	card.card_art.visible = true
	card.card_back.scale.x = 1
	card.card_back.scale.y = 1
	card.card_front.scale.x = 1
	card.card_front.scale.y = 1
	card.card_art.scale.x = 1
	card.card_art.scale.y = 1
	card.add_button.visible = true

func add_card(card):
	var copies := 0
	for copy in deck:
		if card.cardName == copy.cardName:
			copies += 1
	
	if copies >= 3 or len(deck) >= 30:
		return
	
	deck.push_back(card)
	
	if card.tags[0] == "Creature":
		deck_list.add_item(card.cardName, SUMMON_BUTTON)
	else:
		deck_list.add_item(card.cardName, CAST_BUTTON)
	card.reparent(cardsControl)
	card.add_button.visible = false
	
func remove_card(card):
	deck.erase(card)
	card.reparent(cardsControl)
	card.add_button.visible = false
	card.remove_button.visible = false
	deck_list.remove_item(selectedIndex)


func _on_deck_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != 1:
		return
	
	selectedIndex = index
	
	var card = deck[index]
	
	for inspected in inspect_view.get_children():
		inspected.reparent(cardsControl)
		inspected.add_button.visible = false
		inspected.remove_button.visible = false
		if card == inspected:
			return
	
	card.reparent(inspect_view)
	card.inspect_view.visible = true
	card.card_back.visible = false
	card.card_front.visible = true
	card.card_art.visible = true
	card.card_back.scale.x = 1
	card.card_back.scale.y = 1
	card.card_front.scale.x = 1
	card.card_front.scale.y = 1
	card.card_art.scale.x = 1
	card.card_art.scale.y = 1
	card.remove_button.visible = true


func _on_tab_container_tab_changed(tab: int) -> void:
	for card in inspect_view.get_children():
		card.reparent(cardsControl)
		card.add_button.visible = false
