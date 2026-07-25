@tool class_name Level extends Node2D

@export var outline_color := Color("3e3546")

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	_ready_completion_zones()
	exiting_label.add_theme_color_override("font_outline_color", outline_color)
	
	Camera.set_bounds($Bounds.position, $Bounds.size + $Bounds.position)
	PlayerManager.add_player(self)
	PlayerManager.player.died.connect(player_dead)
	RenderingServer.global_shader_parameter_set("outline_color", outline_color)

const EXITING := 1.0
var exiting := EXITING
@onready var exiting_label: RichTextLabel = $UILayer/ExitingLabel
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	_process_exiting(delta)

func _process_exiting(delta: float) -> void:
	if exiting <= 0: return
	
	if Input.is_action_pressed("escape"):
		exiting -= delta
		if exiting <= 0.0:
			Scenes.swap_scene("Level Select")
			await Scenes.faded
			Effects.unintensify()
		exiting_label.text = "Exiting... " + str(snappedf(exiting, 0.1))
		exiting_label.show()
	else:
		exiting = EXITING
		exiting_label.hide()

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

func _ready_completion_zones() -> void:
	for child: Node in $CompletionZones.get_children():
		if child is CompletionZone: child.level_completed.connect(level_completed)

const EXCITOTOXICITY = preload("uid://chwtaluiwow5n")
func _on_count_down_timer_expired() -> void:
	Effects.intensify()
	var excitotoxicity := EXCITOTOXICITY.instantiate()
	add_child(excitotoxicity)
	await Delays.wait(0.2)
	spawn_enzyme()

func player_dead() -> void:
	await Scenes._fade_in(0.333)
	get_tree().reload_current_scene()
	Effects.unintensify()
	Scenes._fade_out(0.25)

func level_completed() -> void:
	var lvl := name.replacen("Level","")
	Scenes.level_completed(int(lvl))
	Scenes.swap_scene("Level Select")
	await Scenes.faded
	Effects.unintensify()

func spawn_enzyme() -> void:
	if $Enemies.get_children().size() < 300:
		var enzyme := preload("uid://d1wd5lnv3285q").instantiate()
		$Enemies.add_child(enzyme)
		var theta := randf_range(-PI, PI)
		var pos_x := 380 * cos(theta) + PlayerManager.player.global_position.x
		var pos_y := 380 * sin(theta) + PlayerManager.player.global_position.y
		enzyme.global_position = Vector2(pos_x, pos_y)
	await Delays.wait(0.125)
	spawn_enzyme()
