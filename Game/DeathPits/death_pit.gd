@tool class_name DeathPit extends Polygon2D

@export var outer := 0.8
@export var inner := 0.6
@export var collider := 0.5
@export var momentum_required := 200.0

func _ready() -> void:
	refresh.call()
	
	if Engine.is_editor_hint(): return
	$FallArea/Collision.polygon = shrink_polygon(polygon, collider)

func _process(_delta: float) -> void:
	_process_falling()


# Visuals
@export_tool_button("Refresh") var refresh := func() -> void:
	update_visuals()

func update_visuals() -> void:
	$Dark.polygon = shrink_polygon(polygon, outer)
	$Dark/Darker.polygon = shrink_polygon(polygon, inner)

func shrink_polygon(array: PackedVector2Array, amount: float) -> PackedVector2Array:
	var temp: Array[Vector2]
	for v in array:
		temp.append(v * amount)
	return PackedVector2Array(temp)


# Falling in
@onready var fall_area: Area2D = $FallArea
func _process_falling() -> void:
	for body in fall_area.get_overlapping_bodies():
		if body is Player:
			if body.get_momentum() < momentum_required and body.grappled_object == null:
				body.die("Pit")
