extends CanvasLayer


func _process(delta: float) -> void:
	_process_screen_effects(delta)



# Afterimages?



# Screen Effects
func _process_screen_effects(delta: float) -> void:
	_brighten = LerpHelper.lf(_brighten, 0.0, 12.0, delta)
	
	$EffectLayer0/Brighten.material.set_shader_parameter("mult", _brighten)
	
	if intensifying:
		i = LerpHelper.lf(i, 0.333, 5.0, delta)
		$EffectLayer1/Intensify.material.set_shader_parameter("rounding", i)

var _brighten := 0.0
func brighten(amount := 1.25) -> void:
	_brighten = amount

var intensifying := false
var i := 10.0
var i_up := false

func intensify() -> void:
	intensifying = true
	i = 10.0
	$EffectLayer1/Intensify.show()

func unintensify() -> void:
	intensifying = false
	$EffectLayer1/Intensify.hide()
