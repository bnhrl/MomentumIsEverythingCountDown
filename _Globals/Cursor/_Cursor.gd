extends CanvasLayer

var position := Vector2(640, 360) * 0.5
var position_prev := position
@onready var cursor_object: Node2D = $CursorObject

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if not using_controller:
		cursor_object.global_position = cursor_object.get_global_mouse_position()
		position = cursor_object.global_position
	else:
		_process_controller(delta)


func set_animation(animation: String = "default") -> void:
	$%Sprite.animation = animation

var using_controller := false
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		show()
		using_controller = false
	elif event is InputEventJoypadButton:
		using_controller = true

func _process_controller(delta: float) -> void:
	if PlayerManager.player and not get_tree().paused: 
		hide()
		return
	else: show()
	
	cursor_object.global_position = position
	position.x = clamp(position.x, 0.0, 640)
	position.y = clamp(position.y, 0.0, 360)
	var input := Input.get_vector("left", "right", "up", "down")
	
	position += input * 200.0 * delta
	if position != position_prev:
		var event := InputEventMouseMotion.new()
		var offputting := get_viewport().get_screen_transform().origin * 1
		var transgender := get_viewport().get_final_transform()
		event.position = offputting + position * transgender.get_scale()
		Input.parse_input_event(event)
		position_prev = position
	
	if Input.is_action_just_pressed("controller_focus_aim"):
		position = Vector2(640, 360) * 0.5
	
	#if Input.is_action_just_pressed("button_press"):
		#var event := InputEventMouseButton.new()
		#event.button_index = MOUSE_BUTTON_LEFT
		#event.pressed = true
		#event.button_mask = 1
		#event.position = position
		#Input.parse_input_event(event)
	#if Input.is_action_just_released("button_press"):
		#var event := InputEventMouseButton.new()
		#event.button_index = MOUSE_BUTTON_LEFT
		#event.pressed = false
		#event.button_mask = 0
		#event.position = position
		#Input.parse_input_event(event)
		
