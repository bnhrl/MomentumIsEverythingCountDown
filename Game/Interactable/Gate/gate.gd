extends Polygon2D

@export var displays_notification := true
@onready var notif: RichTextLabel = $CanvasLayer/Notification

func _ready() -> void:
	$StaticBody/Collision.polygon = polygon
	color.h += randf_range(-100, 100)
	notif.hide()

func _process(delta: float) -> void:
	color.h += delta*0.05
	notif.modulate = color
	if arrow:
		arrow.color = color

const DISABLED_TEXTS := ["An obstacle is cleared...", "Somewhere, a gate opens.", "An obstacle has been removed!"]
var disabled := false
func disable(button: WorldButton = null) -> void:
	if disabled: return
	disabled = true
	if button:
		launch_arrow(button)
	else:
		arrow.queue_free()
	$StaticBody.queue_free()
	if displays_notification:
		notif.text = DISABLED_TEXTS[randi_range(0,DISABLED_TEXTS.size()-1)]
		notif.show()
		var _tween := create_tween()  
		_tween.set_parallel(true)
		_tween.tween_property(notif, "position:y", 310, .75).set_trans(Tween.TRANS_EXPO).from(360)
		_tween.tween_property(notif, "modulate:a", 0.0, 2.5).set_trans(Tween.TRANS_EXPO)
	
	var tween: Tween
	if arrow:
		await _arrow_landed
		tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_EXPO)
	else:
		tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)

@onready var arrow: Polygon2D = $Arrow
signal _arrow_landed
func launch_arrow(button: WorldButton) -> void:
	arrow.global_position = button.global_position
	arrow.show()
	arrow.modulate.a = 0.0
	$Arrow/ArrowTimer.start(0.1)
	var tween := create_tween()
	var pos := Vector2(0,0)
	for point in polygon:
		pos += point
	pos /= polygon.size()
	pos += global_position
	arrow.look_at(pos)
	tween.set_parallel()
	tween.tween_property(arrow, "modulate:a", 1.0, 0.1)
	tween.tween_property(arrow, "global_position", pos, (global_position.distance_to(pos) * 0.01))
	await tween.finished
	_arrow_landed.emit()


func _on_arrow_timer_timeout() -> void:
	var effect := arrow.duplicate()
	add_child(effect)
	effect.global_transform = arrow.global_transform
	var tween := effect.create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 0.333)
	tween.tween_callback(effect.queue_free)
	$Arrow/ArrowTimer.start(0.05)
