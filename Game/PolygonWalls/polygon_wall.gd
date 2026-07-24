extends Polygon2D


func _ready() -> void:
	$StaticBody/Collision.polygon = polygon
