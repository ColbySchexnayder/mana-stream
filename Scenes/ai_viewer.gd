extends Window

@onready var spin_box: SpinBox = $VBoxContainer/HBoxContainer/SpinBox
@onready var tree: Tree = $VBoxContainer/Tree

signal ai_view_button_pressed

func _on_button_pressed() -> void:
	var value = spin_box.value
	emit_signal("ai_view_button_pressed", value)
