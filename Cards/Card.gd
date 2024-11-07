class_name Card extends Node

var cost := 1
var health := 0
var attack := 1
var cardName := "An Overly Verbose And Realy long Text Name Test Name"
var cardDescription := "Rerum beatae aliquam perferendis neque. Quaerat et quisquam sint corrupti optio quis. Voluptas et non qui vitae rerum sint qui sunt.

Ipsa voluptatum tempore omnis eius ipsam sit dolores. Ut quia culpa quis. Et consequuntur fugiat inventore.

Dolores facere sit ea vel harum in cum et. Alias commodi illum autem tenetur. Ut rerum nihil quis. Doloribus molestiae sed dicta quo rerum expedita animi id. Inventore occaecati magnam ut pariatur.

Accusamus in et doloremque ex. Laudantium aut animi quidem sint expedita voluptas omnis. Perferendis hic voluptatem ut at.

Sed soluta non velit quae. Pariatur et corrupti illum neque quis. Reprehenderit id quisquam vero harum ipsum commodi quisquam cupiditate."
var cardLore := "An interesting and curious experience to peer behind the current and glimpse the unknowable"

enum position {
	IN_DECK,
	IN_HAND,
	IN_MANA,
	IN_SUMMON
}

var currentPosition := position.IN_DECK
var exhausted := false
var inspected := 0

@onready var card_front: TextureRect = $CardFront
@onready var cost_text: RichTextLabel = $CardFront/Cost
@onready var health_text: RichTextLabel = $CardFront/Health
@onready var attack_text: RichTextLabel = $CardFront/Attack

@onready var name_text: RichTextLabel = $CardFront/CardName
@onready var description_text: RichTextLabel = $CardFront/CardDescription

@onready var card_back: TextureRect = $CardBack

@onready var inspect_view: Control = $InspectView
@onready var expanded_name: RichTextLabel = $InspectView/ExpandedName
@onready var expanded_description: RichTextLabel = $InspectView/ExpandedDescription
@onready var lore_text: RichTextLabel = $InspectView/LoreText


const CARD = preload("res://Cards/Card.tscn")
static func constructor():
	var obj = CARD.instantiate()
	return obj

func summon() -> void:
	pass

func mana() -> void:
	pass

func action() -> void:
	pass
	
func react() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost_text.text = str(cost)
	health_text.text = str(health)
	attack_text.text = str(attack)
	name_text.text = cardName
	description_text.text = cardDescription
	
	expanded_name.text = cardName
	expanded_description.text = cardDescription
	lore_text.text = cardLore


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	pass # Replace with function body.


func _on_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("activate")):
		GmManager.emit_signal("_card_select", self)
		
	elif (event.is_action_pressed("alternate")):
		if currentPosition == position.IN_HAND:
			card_front.visible = false
			card_back.visible = true
			currentPosition = position.IN_MANA
