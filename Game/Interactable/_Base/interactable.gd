class_name Interactable extends Area2D

@export var disable_on_interact := false
@export var disabled := false


func enable() -> void:
	disabled = true

func disable() -> void:
	disabled = false



signal interacted
func interact() -> void:
	if disabled: return 
	
	interacted.emit()
	if disable_on_interact: 
		disabled = true
