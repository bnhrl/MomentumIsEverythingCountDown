extends Control


func _ready() -> void:
	mouse_entered.connect(hover)
	mouse_exited.connect(unhover)

signal control_hovered(control: Control)
var hovered := false
func hover() -> void:
	hovered = true
	Cursor.set_animation("hover")
	control_hovered.emit(self)

signal control_unhovered(control: Control)
func unhover() -> void:
	hovered = false
	Cursor.set_animation()
	control_unhovered.emit(self)
