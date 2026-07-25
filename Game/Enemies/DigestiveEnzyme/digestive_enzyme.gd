extends Enemy


func _ready() -> void:
	target = PlayerManager.player

func _process_movement(delta: float) -> void:
	if !target: return
	
	var target_direction := global_position.direction_to(target.global_position)
	direction = LerpHelper.lv2(direction, target_direction, 4.0, delta)
	var target_velocity := direction * speed * delta
	velocity = LerpHelper.lv2(velocity, target_velocity, 4.0, delta)
	
	move_and_slide()
