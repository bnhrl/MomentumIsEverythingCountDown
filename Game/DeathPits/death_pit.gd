@tool class_name DeathPit extends Polygon2D

@export var outer := 0.8
@export var inner := 0.6
@export var collider := 0.5
@export var momentum_required := 200.0
@export var build_at_run := true

func _ready() -> void:
	if build_at_run:
		refresh.call()
		$FallArea/Collision.polygon = shrink_polygon(polygon, collider)
	
	if Engine.is_editor_hint(): return
	
	if PlayerManager.easy_mode: momentum_required *= 0.667

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	_process_falling()


# Visuals
@export_tool_button("Refresh") var refresh := func() -> void:
	update_visuals()
	$FallArea/Collision.polygon = shrink_polygon(polygon, collider)

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
	if not PlayerManager.player_added_to_scene: return
	
	for body in fall_area.get_overlapping_bodies():
		if body is Player:
			if body.get_momentum() < momentum_required and body.grappled_object == null and not body.dead:
				body.die("Pit")
