extends Enemy


@onready var tail_l: Line2D = $Model/TailL
@onready var tail_r: Line2D = $Model/TailR
@onready var tail_start: Marker2D = $Model/TailStart
@onready var tail_anchor: Node2D = $Model/TailAnchor
@onready var tail_marker: Marker2D = $Model/TailAnchor/TailMarker

@onready var tail_points: Array = tail_l.points as Array
var prev_angle := global_rotation
func _process_visuals(delta: float) -> void:
	super._process_visuals(delta)
	tail_anchor.global_position = global_position
	tail_anchor.global_rotation = LerpHelper.la(tail_anchor.global_rotation, model.global_rotation, 8.0, delta)
	
	for i in range(tail_points.size()):
		var point: Vector2 = tail_points[i]
		var dist_to_marker := point.distance_to(tail_marker.global_position)
		var target_point := (tail_start.global_position - tail_marker.global_position).rotated(model.global_rotation*-1) * -1
		if i > 0:
			point = LerpHelper.lv2(point, target_point, (dist_to_marker*6-i*dist_to_marker), delta)
		tail_points[i] = point
	
	tail_l.points = PackedVector2Array(tail_points)
	tail_r.points = PackedVector2Array(tail_points)
