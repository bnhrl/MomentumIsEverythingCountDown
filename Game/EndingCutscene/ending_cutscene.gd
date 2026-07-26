extends Node2D


@onready var camera_anchor: Node2D = $CameraAnchor

@onready var background: Sprite2D = $ParallaxBackground/Background
@onready var background_flames: Sprite2D = $ParallaxBackground/Background/BackgroundFlames
@onready var background_cubicle: Sprite2D = $ParallaxBackground/BackgroundCubicle
@onready var background_cubicle_flames: Sprite2D = $ParallaxBackground/BackgroundCubicle/BackgroundCubicleFlames
@onready var guy: Sprite2D = $Guy
@onready var computer: Sprite2D = $Computer
@onready var computer_flames: AnimatedSprite2D = $Computer/ComputerFlames

func _ready() -> void:
	Camera.target = $CameraAnchor
	await step_0()
	await step_1()
	await step_2()
	await step_3()
	await step_4()

const MIDDLE := Vector2(320,180)
func step_0() -> Signal: # Pan down to Man
	$CameraAnchor/FadeOut.hide()
	await Delays.wait(0.5)
	var tween := create_tween()
	tween.tween_property(camera_anchor, "position", MIDDLE, 2).set_trans(Tween.TRANS_EXPO).from(MIDDLE*Vector2(1,-1))
	tween.tween_property(background_flames, "modulate:a", 0.0, 1)
	await tween.finished
	await Delays.wait(1.25)
	await get_tree().process_frame
	$Man.show()
	guy.hide()
	await get_tree().process_frame
	guy.show()
	$Man.hide()
	return get_tree().process_frame

func step_1() -> Signal: # Man face
	background.hide()
	guy.texture = preload("uid://bjvuyd3auatfx")
	await Delays.wait(2.0)
	var tween := create_tween()
	tween.tween_property(background_cubicle_flames, "modulate:a", 0.0, 1.75)
	await tween.finished
	await Delays.wait(1.75)
	return Delays.wait(1.0)

func step_2() -> Signal: # Computer
	guy.hide()
	background.show()
	computer.show()
	await Delays.wait(2.0)
	var tween := create_tween()
	tween.tween_property(computer_flames, "modulate:a", 0.0, 1.75)
	await tween.finished
	return Delays.wait(1.0)

func step_3() -> Signal: # Detailed Credits
	await Delays.wait(1.25)
	$CameraAnchor/FadeOut.show()
	var tween := create_tween()
	tween.tween_property($CameraAnchor/FadeOut, "modulate:a", 1.0, 3.0).from(0.0)
	await tween.finished
	await Delays.wait(0.5)
	$CameraAnchor/FadeOut/Bnhrl.show()
	await Delays.wait(6.0)
	$CameraAnchor/FadeOut/Bnhrl.hide()
	$CameraAnchor/FadeOut/CatJug.show()
	await Delays.wait(6.0)
	$CameraAnchor/FadeOut/CatJug.hide()
	$CameraAnchor/FadeOut/Cuptain.show()
	await Delays.wait(6.0)
	$CameraAnchor/FadeOut/Cuptain.hide()
	return Delays.wait(1.0)

func step_4() -> void: # The End
	await Delays.wait(1.0)
	var tween := create_tween()
	tween.tween_property($CameraAnchor/FadeOut/TheEnd, "modulate:a", 1.0, 3.0).from(0.0)
	await tween.finished
	tween = create_tween()
	tween.tween_property($CameraAnchor/FadeOut/BtnMainMenu, "modulate:a", 1.0, 3.0).from(0.0)
	await tween.finished
	return Delays.wait(1.0)
	


func _on_btn_main_menu_pressed() -> void:
	Scenes.swap_scene("Main Menu")
