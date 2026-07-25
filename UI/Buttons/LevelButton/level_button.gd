@tool class_name LeveLButton extends UIButton

@export var level: int = 0

func press() -> void:
	super.press()
	Scenes.swap_scene("Level " + str(level))
