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
var tags = ['Creature', 'testbug']
enum position {
	IN_DECK,
	IN_HAND,
	IN_MANA,
	IN_SUMMON
}

var currentPosition := position.IN_DECK
var paid := false
var exhausted := false
var revealed := true
var cardOwner := 1

@onready var card: Card = $"."

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
@onready var tag_text: RichTextLabel = $InspectView/TagText

@onready var mana_button: TextureButton = $InspectView/ManaButton
@onready var summon_button: TextureButton = $InspectView/SummonButton
@onready var attack_button: TextureButton = $InspectView/AttackButton
@onready var block_button: TextureButton = $InspectView/BlockButton
@onready var keep_button: TextureButton = $InspectView/KeepButton

@onready var card_art: TextureRect = $CardArt
@onready var add_button: TextureButton = $InspectView/AddButton
@onready var remove_button: TextureButton = $InspectView/RemoveButton

const CARD = preload("res://Cards/Card.tscn")
static func constructor():
	var obj = CARD.instantiate()
	return obj

func summon() -> void:
	await GmManager._interrupt_resolved
	print("summoned")
	pass

func mana() -> void:
	if currentPosition == position.IN_HAND and GmManager.currentPhase == GmManager.phase.PLAY:
			card_front.visible = false
			card_art.visible = false
			card_back.visible = true
			currentPosition = position.IN_MANA
			GmManager.emit_signal("_card_to_mana", self)
	elif currentPosition == position.IN_MANA and !exhausted:
			GmManager.emit_signal("_add_to_mana", self, 1)
			exhaust(self)

func attacking() -> void:
	pass

func action() -> void:
	pass
	
func block() -> void:
	exhaust(self)
	GmManager.emit_signal("_card_block", self)
	

#Tentatively @cause. 0: Resolving card. 1: from battle. 2:from card effect. 3. Cost not paid more to be added?
func destroy(cause: int) -> void:
	GmManager.emit_signal("_move_to_deck", card)

func exhaust(card)-> void:
	if card.exhausted:
		return
	card.exhausted = true
	card.card_back.scale.x = .5
	card.card_back.scale.y = .5
	card.card_front.scale.x = .5
	card.card_front.scale.y = .5
	card.card_art.scale.x = .5
	card.card_art.scale.y = .5

func resolve_summon()->void:
	return
	
func refresh()->void:
	paid = false
	exhausted = false
	card_back.scale.x = 1
	card_back.scale.y = 1
	card_front.scale.x = 1
	card_front.scale.y = 1
	card_art.scale.x = 1
	card_art.scale.y = 1


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
	tag_text.text = tags[0] + ", " + tags[1]
	
	summon_button.hide()
	attack_button.hide()
	block_button.hide()
	
	GmManager.connect("_card_exhaust", exhaust)
	GmManager.connect("_card_activate", action)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	pass # Replace with function body.


func _on_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("activate")):
		GmManager.emit_signal("_card_select", self)
		
	elif (event.is_action_pressed("alternate")) and card.cardOwner == 1 and GmManager.currentTurn == 1:
		mana()


func _on_summon_button_pressed() -> void:
	GmManager.emit_signal("_card_summon", self)
	summon()


func _on_attack_button_pressed() -> void:
	GmManager.emit_signal("_card_attack", self)
	attacking()
	#GmManager.emit_signal("_card_select", self)


func _on_block_button_pressed() -> void:
	block() # Replace with function body.


func _on_add_button_pressed() -> void:
	GmManager.emit_signal("_card_add", self)


func _on_remove_button_pressed() -> void:
	GmManager.emit_signal("_card_remove", self)


func _on_keep_button_pressed() -> void:
	GmManager.emit_signal("_card_keep", self)


func _on_mana_button_pressed() -> void:
	GmManager.emit_signal("_card_select", self)
	mana()
