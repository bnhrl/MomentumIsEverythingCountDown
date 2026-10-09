@tool class_name LevelButton extends UIButton

@export var level: int = 0
signal level_button_pressed(_level: int, button: LevelButton)

func press() -> void:
	super.press()
	level_button_pressed.emit(level, self)
