class_name GrapplePoint extends Area2D


signal grappled
signal released

func grapple() -> void:
	grappled.emit()

func release() -> void:
	released.emit()

func _on_body_entered(body: Node2D) -> void:
	if body is Player: body.passed_grapple_object()
