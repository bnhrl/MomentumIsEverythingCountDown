extends Control

@onready var buttons: Array[UIButton] = [$BtnBnhrl, $BtnCatJug, $BtnCuptain]
func _ready() -> void:
	buttons.shuffle()
	for i in range(buttons.size()):
		buttons[i].position.y = 124.0 + 55*i
