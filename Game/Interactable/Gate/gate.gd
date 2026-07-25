extends Polygon2D


@onready var notif: RichTextLabel = $CanvasLayer/Notification

func _ready() -> void:
	$StaticBody/Collision.polygon = polygon
	color.h += randf_range(-100, 100)
	notif.hide()

func _process(delta: float) -> void:
	color.h += delta*0.05
	notif.modulate = color

const DISABLED_TEXTS := ["An obstacle is cleared...", "Somewhere, a gate opens.", "An obstacle has been removed!"]
func disable() -> void:
	$StaticBody.queue_free()
	notif.text = DISABLED_TEXTS[randi_range(0,2)]
	notif.show()
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(notif, "position:y", 310, .75).set_trans(Tween.TRANS_EXPO).from(360)
	tween.parallel().tween_property(notif, "modulate:a", 0.0, 2.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)
