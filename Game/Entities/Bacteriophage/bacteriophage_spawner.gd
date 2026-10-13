extends Node2D


@export var min_phages := 8
@export var max_phages := 12

const BACTERIOPHAGE = preload("uid://d24wa4jn2kt1o")

func _ready() -> void:
	var chosen := randi_range(min_phages, max_phages)
	for i in range(chosen):
		var phage := BACTERIOPHAGE.instantiate()
		add_child(phage)
