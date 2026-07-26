@tool class_name BoostPad extends Polygon2D

@export_range(-360, 360) var direction := 0.0:
	set(new):
		direction = new
		refresh()
@export var speed := 100.0

func _ready() -> void:
	refresh()
	if Engine.is_editor_hint(): return
	
	$Area/Collision.polygon = polygon

@onready var area: Area2D = $Area
func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	for body in area.get_overlapping_bodies():
		if body is Player:
			body.momentum += Vector2.from_angle(deg_to_rad(direction)) * speed
			body.velocity += Vector2.from_angle(deg_to_rad(direction)) * speed
		elif body is Enemy:
			body.velocity += Vector2.from_angle(deg_to_rad(direction)) * speed

func refresh() -> void:
	material.set_shader_parameter("rotation", deg_to_rad(direction))
