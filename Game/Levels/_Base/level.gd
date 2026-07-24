@tool class_name Level extends Node2D


func _ready() -> void:
	if Engine.is_editor_hint(): return
	Camera.set_bounds($Bounds.position, $Bounds.size + $Bounds.position)

@export_tool_button("Rebake Navigation") var rebake := func() -> void:
	$NavigationRegion.navigation_polygon = $NavigationRegion.navigation_polygon.duplicate()
	$NavigationRegion.bake_navigation_polygon()
