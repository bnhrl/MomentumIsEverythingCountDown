extends CanvasLayer


func _process(delta: float) -> void:
	_process_screen_effects(delta)



# Afterimages?



# Screen Effects
func _process_screen_effects(delta: float) -> void:
	if obscuring:
		$EffectLayer2/Obscur.modulate.a = LerpHelper.lf($EffectLayer2/Obscur.modulate.a, 1.0, 9.0, delta)
		$EffectLayer2/Obscur.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		$EffectLayer2/Obscur.modulate.a = LerpHelper.lf($EffectLayer2/Obscur.modulate.a, 0.0, 9.0, delta)
		$EffectLayer2/Obscur.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if get_tree().paused: return
	
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

var obscuring := false
func obscure() -> void:
	obscuring = true

func unobscure() -> void:
	obscuring = false
