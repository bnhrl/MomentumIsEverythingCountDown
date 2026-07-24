@tool class_name UIButton extends RichTextLabel


func _ready() -> void:
	add_theme_color_override("default_color", default_color)

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	_process_hovering(delta)
	_process_pressing()

@export_tool_button("Refresh") var refresh := func() -> void:
	add_theme_color_override("default_color", default_color)


# Hovering
@export var default_color := Color("4d65b4")
@export var hover_color := Color("e83b3b")
@export var hover_size := Vector2(1.5, 1.5)
var hovered := false
@onready var color := default_color

func hover() -> void:
	hovered = true

func unhover() -> void:
	hovered = false

func _process_hovering(delta: float) -> void:
	if !hovered:
		offset_transform_scale.x = LerpHelper.lf(offset_transform_scale.x, 1.0, 16.0, delta)
		offset_transform_scale.y = LerpHelper.lf(offset_transform_scale.y, 1.0, 4.0, delta)
		color = LerpHelper.l(color, default_color, 9.0, delta)
	else:
		offset_transform_scale.x = LerpHelper.lf(offset_transform_scale.x, hover_size.x, 16.0, delta)
		offset_transform_scale.y = LerpHelper.lf(offset_transform_scale.y, hover_size.y, 4.0, delta)
		color = LerpHelper.l(color, hover_color, 9.0, delta)
	add_theme_color_override("default_color", color)


# Pressing
signal pressed
signal pressed_self(btn: UIButton) ## In case you need to reference the button that emitted the signal.

func _process_pressing() -> void:
	if Input.is_action_just_pressed("button_press") and hovered: press()

func press() -> void:
	pressed.emit()
	pressed_self.emit(self)
