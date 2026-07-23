class_name LerpHelper

## Does what lerp does, but takes weight and delta as separate parameters. Use in _process functions. 
static func l(from: Variant, to: Variant, prev_weight: float, delta: float) -> Variant:
	return lerp(from, to, 1 - exp(-prev_weight * delta))

## Does what lerp_angle does, but takes weight and delta as separate parameters. Use in _process functions. 
static func la(from: float, to: float, prev_weight: float, delta: float) -> float:
	return lerp_angle(from, to, 1 - exp(-prev_weight * delta))

## Same as LerpHelper.l, but type-safe for floats.
static func lf(from: float, to: float, prev_weight: float, delta: float) -> float:
	return lerpf(from, to, 1 - exp(-prev_weight * delta))

## Same as LerpHelper.l, but type-safe for Vector2s.
static func lv2(from: Vector2, to: Vector2, prev_weight: float, delta: float) -> Vector2:
	return from.lerp(to, 1 - exp(-prev_weight * delta))

## Same as LerpHelper.l, but type-safe for Vector3s.
static func lv3(from: Vector3, to: Vector3, prev_weight: float, delta: float) -> Vector3:
	return from.lerp(to, 1 - exp(-prev_weight * delta))

## Returns a weight for use in _process functions.
static func w(prev_weight: float, delta: float) -> float:
	return 1 - exp(-prev_weight * delta)
