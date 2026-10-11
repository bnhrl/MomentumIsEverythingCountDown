extends Node2D


@export var target: LevelButton
var anchors: Array[Node2D]


func _ready() -> void:
	if not target: hide()
	for child in get_children():
		anchors.append(child)

func _process(delta: float) -> void:
	if not target: 
		return
	
	var target_position := target.global_position + target.size / 2.0 - Vector2(1.0, 0.0)
	for i in range(anchors.size()):
		if i % 2 == 0: anchors[i].rotation += delta
		else:          anchors[i].rotation -= delta
		if target:
			anchors[i].global_position = LerpHelper.lv2(anchors[i].global_position, target_position, (i+1) * 3.0, delta)


func set_target(t: LevelButton) -> void:
	target = t
	if not visible or not target:
		global_position = target.global_position + target.size / 2.0 - Vector2(1.0, 0.0)
		show()
