extends Node2D

var player1deck := []
var player1hand := []
var player1summon := []
var player1mana := []

var player2deck := []
var player2hand := []
var player2summon := []
var player2mana := []

@onready var p_1_hand: HBoxContainer = $Control/Player1Zone/P1Hand
const CARD = preload("res://Cards/Card.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var p1HandSeperationRatio = 1/ (1+player1hand.size())
	p_1_hand.add_theme_constant_override("separation", p1HandSeperationRatio)


func _on_p_1_deck_pressed() -> void:
	pass
