class_name CompletionZone extends Node2D


var completed := false
signal level_completed
func _on_detection_zone_body_entered(body: Node2D) -> void:
	if completed: return
	
	if body is Player: 
		level_completed.emit()
		completed = true
