class_name CompletionZone extends Node2D


@export var game_completion := false

func _ready() -> void:
	var beam_tween := create_tween()
	beam_tween.set_loops()
	beam_tween.tween_property($BeamAnchor, "scale:x", 1.2, 1.0).set_trans(Tween.TRANS_CUBIC)
	beam_tween.tween_property($BeamAnchor, "scale:x", 1.5, 1.0).set_trans(Tween.TRANS_CUBIC)
	var pad_tween := create_tween()
	pad_tween.set_loops()
	pad_tween.tween_property($PadAnchor, "scale:x", 1.2, 1.0).set_trans(Tween.TRANS_CIRC)
	pad_tween.tween_property($PadAnchor, "scale:x", 1.5, 1.0).set_trans(Tween.TRANS_CIRC)


var completed := false
signal level_completed(game: bool)
func _on_detection_zone_body_entered(body: Node2D) -> void:
	if completed: return
	
	if body is Player: 
		level_completed.emit(game_completion)
		completed = true
