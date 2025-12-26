extends Window

@onready var spin_box: SpinBox = $VBoxContainer/HBoxContainer/SpinBox

signal ai_view_button_pressed

func _on_button_pressed() -> void:
	var value = spin_box.value
	emit_signal("ai_view_button_pressed", value)
