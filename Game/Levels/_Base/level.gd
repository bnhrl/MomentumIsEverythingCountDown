@tool class_name Level extends Node2D

@export var outline_color := Color("3e3546")

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	Camera.set_bounds($Bounds.position, $Bounds.size + $Bounds.position)
	PlayerManager.add_player(self)
	PlayerManager.player.died.connect(player_dead)
	RenderingServer.global_shader_parameter_set("outline_color", outline_color)

@export_tool_button("Rebake Navigation") var rebake := func() -> void:
	$NavigationRegion.show()
	var bounds_rect: Rect2 = $Bounds.get_rect()
	var points := PackedVector2Array([
		bounds_rect.position,
		bounds_rect.position+Vector2(bounds_rect.size.x, 0.0),
		bounds_rect.position + bounds_rect.size,
		bounds_rect.position+Vector2(0.0, bounds_rect.size.y),
	])
	
	var nav_poly: NavigationPolygon = $NavigationRegion.navigation_polygon.duplicate()
	nav_poly.clear_outlines()
	nav_poly.add_outline(points)
	$NavigationRegion.navigation_polygon = nav_poly
	$NavigationRegion.bake_navigation_polygon()
	await get_tree().create_timer(0.75).timeout
	$NavigationRegion.hide()

func get_player_spawn_point() -> Vector2:
	return $PlayerSpawnPoint.global_position

func _on_count_down_timer_expired() -> void:
	Effects.intensify()

func player_dead() -> void:
	await Scenes._fade_in(0.25)
	get_tree().reload_current_scene()
	Scenes._fade_out(0.25)
