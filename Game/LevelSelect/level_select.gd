class_name LevelSelect extends Control


func _ready() -> void:
	Data.save()
	RenderingServer.global_shader_parameter_set("outline_color", Color("9babb2"))
	var level_buttons := $LevelButtons.get_children()
	for i in range(level_buttons.size()):
		if level_buttons[i] is LevelButton:
			if level_buttons[i].level > Scenes.current_level:
				level_buttons[i].hide()
	if Scenes.current_level >= 11:
		$Brain/Brain.texture = preload("uid://b6pf0e8m7bidm")
	elif Scenes.current_level >= 9:
		$Brain/Brain.texture = preload("uid://dhsdoswq62d2")
	elif Scenes.current_level >= 4:
		$Brain/Brain.texture = preload("uid://66tu2soentk")
	
	if PlayerManager.easy_mode: mode_sprite.animation = "easy"
	else:                       mode_sprite.animation = "hard"
	
	for button in $LevelButtons.get_children():
		button.level_button_pressed.connect(select_level)
	if Data.save_data.get("current_level", 1) <= 12:
		select_level(Data.save_data.get("current_level", 1), $LevelButtons/BtnLevel1)
	else:
		select_level(12, $LevelButtons/BtnLevel12)
	
	if Scenes.current_level >= 13:
		$BtnRewatch.show()

func _on_btn_main_menu_pressed() -> void:
	Scenes.swap_scene("Main Menu")

func _on_btn_show_level_buttons_pressed() -> void:
	for child in $LevelButtons.get_children():
		child.show()


# Levels
const LEVEL_NAMES: Dictionary[int, String] = {
	 0: "NO DON'T",
	 1: "temporal a",
	 2: "temporal b",
	 3: "temporal c",
	 4: "frontal a",
	 5: "frontal b",
	 6: "frontal c",
	 7: "frontal d",
	 8: "parietal a",
	 9: "parietal b",
	10: "parietal c",
	11: "occipital a",
	12: "occipital b",
}
const LEVEL_THUMBSNAILS: Dictionary[int, Texture2D] = {
	 1: preload("uid://ym71ns7c4280"),
	 2: preload("uid://cluvqmh006i83"),
	 3: preload("uid://cgicy000s73iv"),
	 4: preload("uid://ep286ejvtx42"),
	 5: preload("uid://cgatmg7hpg2j6"),
	 6: preload("uid://c40p8kdgrkqv5"),
	 7: preload("uid://dncvdf4xim8v5"),
	 8: preload("uid://7q520uq8py45"),
	 9: preload("uid://b7xp2jk7aso77"),
	10: preload("uid://bpuptrsb86qda"),
	11: preload("uid://bc1webkmd7kdd"),
	12: preload("uid://ch26b76f2yf6i"),
}

@onready var selector: CanvasGroup = $Selector
var level: int = 1
@onready var level_label: RichTextLabel = $Hud/LevelLabel
@onready var level_thumbnail: TextureRect = $Hud/LevelThumbnail
func select_level(l: int, button: LevelButton) -> void:
	level = l
	level_label.text = "[tornado freq=5 radius=2.0]"+LEVEL_NAMES.get(level)
	level_thumbnail.texture = LEVEL_THUMBSNAILS.get(level)
	selector.target = button

func _on_btn_go_pressed() -> void:
	Scenes.swap_scene("Level " + str(level))


# Mode
@onready var mode_sprite: AnimatedSprite2D = %BtnMode/Sprite
func _on_btn_mode_pressed() -> void:
	if PlayerManager.easy_mode:
		PlayerManager.easy_mode = false
		mode_sprite.animation = "hard_hover"
	else:
		PlayerManager.easy_mode = true
		mode_sprite.animation = "easy_hover"
	Data.save()

func _on_btn_mode_button_hovered(_button: UIButton) -> void:
	mode_sprite.animation += "_hover"

func _on_btn_mode_button_unhovered(_button: UIButton) -> void:
	mode_sprite.animation = mode_sprite.animation.left(4)


# Rewatch
func _on_btn_rewatch_pressed() -> void:
	Scenes.swap_scene("Ending Cutscene")
