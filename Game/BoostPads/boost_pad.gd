@tool class_name BoostPad extends Polygon2D

@export_range(-360, 360) var direction := 0.0:
	set(new):
		direction = new
		refresh()
@export var speed := 1000.0

func _ready() -> void:
	$Area/Collision.polygon = polygon
	refresh()


func refresh() -> void:
	material.set_shader_parameter("rotation", deg_to_rad(direction))

func _on_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.momentum += Vector2.from_angle(deg_to_rad(direction)) * speed
		body.velocity += Vector2.from_angle(deg_to_rad(direction)) * speed
	elif body is Enemy:
		body.velocity += Vector2.from_angle(deg_to_rad(direction)) * speed
