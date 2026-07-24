@tool class_name Level extends Node2D

@export var outline_color := Color("3e3546")

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	Camera.set_bounds($Bounds.position, $Bounds.size + $Bounds.position)
	PlayerManager.add_player(self)
	RenderingServer.global_shader_parameter_set("outline_color", outline_color)

@export_tool_button("Rebake Navigation") var rebake := func() -> void:
	$NavigationRegion.show()
	$NavigationRegion.navigation_polygon = $NavigationRegion.navigation_polygon.duplicate()
	$NavigationRegion.bake_navigation_polygon()
	await get_tree().create_timer(0.75).timeout
	$NavigationRegion.hide()

func get_player_spawn_point() -> Vector2:
	return $PlayerSpawnPoint.global_position
