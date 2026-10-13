extends CanvasLayer


func _ready() -> void:
	close(0.0)

func _process(_delta: float) -> void:
	label.visible_characters = int(visible_characters)
	if not opened: return
	if Input.is_action_just_pressed("escape") and not closing and get_tree().paused:
		close()


const OPEN_TIME := 0.3
@onready var label: RichTextLabel = $CanvasGroup/Label
var visible_characters := 34.0
var tween: Tween
var closing := false
var opened := false
func open(time_mult := 1.0) -> void:
	get_viewport().set_input_as_handled()
	opened = true
	get_tree().paused = true
	Effects.obscure()
	Music.set_filter(150)
	show()
	
	if tween: tween.kill()
	tween = create_tween()
	
	tween.set_parallel(true)
	tween.set_ignore_time_scale()
	tween.tween_property(self, "visible_characters", label.get_total_character_count(), 0.5*time_mult)
	tween.tween_property(%SideLeft, "position:x", 83, OPEN_TIME*time_mult).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%SideRight, "position:x", 554, OPEN_TIME*time_mult).set_trans(Tween.TRANS_CIRC)
	tween.tween_property($CanvasGroup, "modulate:a", 1.0, OPEN_TIME*time_mult).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(%Back, "modulate:a", 0.5, OPEN_TIME*time_mult).set_trans(Tween.TRANS_EXPO)
	tween.set_parallel(false)
	tween.tween_property(self, "closing", false, 0.0)

func close(time_mult := 1.0) -> void:
	closing = true
	opened = false
	get_tree().paused = false
	Effects.unobscure()
	Music.set_filter()
	
	if tween: tween.kill()
	tween = create_tween()
	
	tween.set_ignore_time_scale()
	tween.set_parallel(true)
	tween.tween_property(self, "visible_characters", 0.0, OPEN_TIME*time_mult)
	tween.tween_property(%SideLeft, "position:x", 83 - 180, OPEN_TIME*time_mult).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%SideRight, "position:x", 554 + 180, OPEN_TIME*time_mult).set_trans(Tween.TRANS_CIRC)
	tween.tween_property($CanvasGroup, "modulate:a", 0.0, OPEN_TIME*time_mult).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(%Back, "modulate:a", 0.0, OPEN_TIME*time_mult).set_trans(Tween.TRANS_EXPO)
	tween.set_parallel(false)
	tween.tween_callback(hide)


func _on_btn_menu_pressed() -> void:
	if closing: return
	
	closing = true
	Effects.unintensify()
	Scenes.swap_scene("Level Select")
	await Scenes.faded
	close(0.0)
