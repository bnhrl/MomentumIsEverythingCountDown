extends CanvasLayer


func _ready() -> void:
	close(0.0)

func _process(_delta: float) -> void:
	label.visible_characters = int(visible_characters)
	if Input.is_action_just_pressed("escape"):
		Scenes.swap_scene("Level Select")
		await Scenes.faded
		close(0.0)


const OPEN_TIME := 0.3
@onready var label: RichTextLabel = $CanvasGroup/Label
var visible_characters := 34.0
var tween: Tween
func open(time_mult := 1.0) -> void:
	get_tree().paused = true
	Effects.obscure()
	
	if tween: tween.kill()
	tween = create_tween()
	
	tween.set_parallel(true)
	tween.set_ignore_time_scale()
	tween.tween_property(self, "visible_characters", label.get_total_character_count(), 0.5*time_mult)
	tween.tween_property(%SideLeft, "position:x", 83, OPEN_TIME*time_mult).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%SideRight, "position:x", 554, OPEN_TIME*time_mult).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%Back, "modulate:a", 0.5, OPEN_TIME*time_mult).set_trans(Tween.TRANS_EXPO)

func close(time_mult := 1.0) -> void:
	get_tree().paused = false
	Effects.unobscure()
	
	if tween: tween.kill()
	tween = create_tween()
	
	tween.set_ignore_time_scale()
	tween.set_parallel(true)
	tween.tween_property(self, "visible_characters", 0.0, OPEN_TIME*time_mult)
	tween.tween_property(%SideLeft, "position:x", 83 - 180, OPEN_TIME*time_mult).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%SideRight, "position:x", 554 + 180, OPEN_TIME*time_mult).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%Back, "modulate:a", 0.0, OPEN_TIME*time_mult).set_trans(Tween.TRANS_EXPO)
