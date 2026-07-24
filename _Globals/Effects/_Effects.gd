extends CanvasLayer


func _process(delta: float) -> void:
	_process_screen_effects(delta)



# Afterimages?



# Screen Effects
func _process_screen_effects(delta: float) -> void:
	_brighten = LerpHelper.lf(_brighten, 0.0, 12.0, delta)
	
	$Brighten.material.set_shader_parameter("mult", _brighten)

var _brighten := 0.0
func brighten(amount := 1.25) -> void:
	_brighten = amount
