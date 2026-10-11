@tool class_name Level extends Node2D

@export var outline_color := Color("3e3546")
@onready var time_label: RichTextLabel = $UILayer/TimeLabel

func _ready() -> void:
	if Engine.is_editor_hint(): 
		print_rich("[rainbow][font_size=32]Make sure to rebake your Navigation when necessary!")
		return
	
	_ready_completion_zones()
	
	if $NavigationRegion.navigation_polygon == null or $NavigationRegion.navigation_polygon.get_polygon_count() <= 0:
		rebake.call()
		push_error("Navigation is not baked on " + name + "! Fix that!!")
	
	Camera.set_bounds($Bounds.position, $Bounds.size + $Bounds.position)
	PlayerManager.add_player(self)
	PlayerManager.player.died.connect(player_dead)
	RenderingServer.global_shader_parameter_set("outline_color", outline_color)
	Music.set_pitch()
	$CountDownTimer.show()
	if PlayerManager.easy_mode:
		$CountDownTimer.multiply_time(1.5)

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if not completed:
		time_elapsed += delta
		time_label.text = str(snappedf(time_elapsed, 0.01)).pad_decimals(2) + "s"
	
	if Input.is_action_just_pressed("restart") and !completed:
		player_dead()

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
		if child is CompletionZone: 
			if !child.level_completed.is_connected(level_completed):
				child.level_completed.connect(level_completed)

const EXCITOTOXICITY = preload("uid://chwtaluiwow5n")
func _on_count_down_timer_expired() -> void:
	if completed: return
	
	if not is_player_dead:
		Music.set_pitch(1.25)
	Effects.intensify()
	var excitotoxicity := EXCITOTOXICITY.instantiate()
	add_child(excitotoxicity)
	await Delays.wait(0.2)
	spawn_enzyme()

var is_player_dead := false
func player_dead() -> void:
	if completed: return
	
	is_player_dead = true
	Music.set_pitch(0.5, 0.05)
	GameTime.set_temp_scale(0.5)
	await Scenes._fade_in(0.67)
	if !get_tree(): return
	get_tree().reload_current_scene()
	Effects.unintensify()
	Scenes._fade_out(0.25)

var completed := false
@onready var complete_label: RichTextLabel = $UILayer/CompleteLabel
func level_completed(game_completed := false) -> void:
	if completed: return
	
	completed = true
	Effects.brighten(5)
	complete_label.show()
	var tween := create_tween()
	tween.tween_property(complete_label, "offset_transform_scale:x", 1.0, 0.25).from(0.0)
	tween.parallel().tween_property(complete_label, "offset_transform_scale:y", 1.0, 0.333).from(0.0)
	PlayerManager.player.level_completed()
	Music.set_pitch()
	$CountDownTimer.process_mode = Node.PROCESS_MODE_DISABLED
	Data.save()
	
	if not game_completed:
		await Delays.wait(0.5)
		var lvl := name.replacen("Level","")
		Scenes.level_completed(int(lvl), time_elapsed)
		Scenes.swap_scene("Level Select")
		await Scenes.faded
		Effects.unintensify()
	else:
		Scenes.current_level += 1
		Data.save()
		await Delays.wait(1.0)
		Effects.unintensify()
		Scenes.swap_scene("Ending Cutscene")

func spawn_enzyme() -> void:
	if $Enemies.get_children().size() < 50:
		var enzyme := preload("uid://d1wd5lnv3285q").instantiate()
		$Enemies.add_child(enzyme)
		var theta := randf_range(-PI, PI)
		var pos_x := 380 * cos(theta) + PlayerManager.player.global_position.x
		var pos_y := 380 * sin(theta) + PlayerManager.player.global_position.y
		enzyme.global_position = Vector2(pos_x, pos_y)
	await Delays.wait(0.125)
	spawn_enzyme()

var time_elapsed := 0.0
func _process_timer(delta: float) -> void:
	time_elapsed += delta
