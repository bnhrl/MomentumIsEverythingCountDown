@tool extends Level


func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint(): return
	
	if PlayerManager.easy_mode:
		$CountDownTimer.time = 15.0
