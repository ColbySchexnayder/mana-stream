class_name Card extends Node

var cost := 0
var health := 0
var attack := 0

enum position {
	IN_DECK,
	IN_HAND,
	IN_MANA,
	IN_SUMMON
}

var currentPosition := position.IN_DECK
var exhausted := false

const CARD = preload("res://Cards/Card.tscn")
static func constructor():
	var obj = CARD.instantiate()
	return obj

func onPlay() -> void:
	pass

func action() -> void:
	pass
	
func react() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
