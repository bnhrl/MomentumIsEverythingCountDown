extends CanvasLayer


@onready var cursor_object: Node2D = $CursorObject

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta: float) -> void:
	cursor_object.global_position = cursor_object.get_global_mouse_position()

func set_animation(animation: String = "default") -> void:
	$%Sprite.animation = animation
