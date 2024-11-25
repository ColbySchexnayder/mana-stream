extends Control

var cards = []
var cardNames = []
var deck = []

@onready var card_list: ItemList = $TabContainer/CardList
@onready var deck_list: ItemList = $TabContainer/DeckList
@onready var cardsControl: Control = $Cards

const CAST_BUTTON = preload("res://Art/castButton.png")
const SUMMON_BUTTON = preload("res://Art/summonButton.png")
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
			#card_list.add_child(cards[count])
			#card_list.add_item(cards[count].cardName)#fileName.substr(0, fileName.length()-5))
			
			if cards[count].tags[0] == "Creature":
				card_list.add_item(cards[count].cardName, SUMMON_BUTTON)
			else:
				card_list.add_item(cards[count].cardName, CAST_BUTTON)
			print(cards[count].tags[0] +"\n" + cards[count].cardName + "\n\n")
			count+=1

	dir.list_dir_end()
	
	print(cards[0].cardName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
