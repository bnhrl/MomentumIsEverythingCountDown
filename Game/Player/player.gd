class_name Player extends CharacterBody2D


const SPEED = 250.0

var momentum := Vector2.ZERO

func _ready() -> void:
	_ready_tail()
	Camera.target = self
	grapple_direction_indicator.hide()

func _physics_process(delta: float) -> void:
	_process_movement(delta)
	_process_tail(delta)
	_process_visuals(delta)
	_process_grabber()
	_process_grappling(delta)


# Movement
func _process_movement(delta: float) -> void:
	if dead: return
	
	var input_direction := Input.get_vector("left", "right", "up", "down")
	if grappled_object: 
		input_direction = Vector2.ZERO
	
	velocity = input_direction * SPEED + momentum
	momentum = LerpHelper.lv2(momentum, Vector2.ZERO, 3.0, delta)
	
	#print("Current Momentum: " + str(int(momentum.length())))
	
	move_and_slide()
	if get_momentum() >= 100: # Ricocheting
		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			if collision:
				var collider := collision.get_collider()
				if collider is BouncyObject:
					momentum = momentum.bounce(collision.get_normal()) * collider.ricochet_speed_mult
					velocity = velocity.bounce(collision.get_normal()) * collider.ricochet_speed_mult
				else:
					momentum = momentum.bounce(collision.get_normal())*0.8
					velocity = velocity.bounce(collision.get_normal())*0.8
				Camera.add_shake(clampf(get_momentum()*0.005, 0.0, 2.5))
				$RicochetSoundPlayer.stream = _RICOCHET_AUDIOS[randi_range(0, 2)]
				$RicochetSoundPlayer.pitch_scale = randf_range(0.9, 1.1)
				$RicochetSoundPlayer.play()
				break

func get_momentum() -> float:
	return momentum.length()


# Tail
const DEFAULT_TAIL_DIST := 8.0
const RETRACTED_TAIL_DIST := 3.0
const GRAPPLING_TAIL_DIST := 40.0
var target_tail_dist := DEFAULT_TAIL_DIST
var tail_dist := DEFAULT_TAIL_DIST
@onready var tail: Line2D = $Model/Tail
var tail_points: Array[Vector2]

func _ready_tail() -> void:
	tail_points.assign(tail.points)
	for i in range(tail_points.size()-2):
		tail_points[i+2] = Vector2.ZERO

func _process_tail(delta: float) -> void:
	if dead: return
	
	tail_dist = LerpHelper.lf(tail_dist, target_tail_dist, 12.0, delta)
	tail.width = clampf(DEFAULT_TAIL_DIST/tail_dist*12.0, 5.0, 16.0)
	
	var direction := global_position.direction_to(get_global_mouse_position())
	if grappled_object: direction = global_position.direction_to(grappled_object.global_position)
	elif attempting_to_grapple: direction = grapple_direction
	tail_points[1] = direction * tail_dist
	
	var lerp_mult := 0.5
	if attempting_to_grapple: lerp_mult = 5.0
	elif retracting_tail: lerp_mult = 16.0
	for i in range(tail_points.size()-2):
		var point := tail_points[i+2]
		var target := direction * i*tail_dist
		point = LerpHelper.lv2(point, target, (tail_dist*7-i*tail_dist)*lerp_mult, delta)
		tail_points[i+2] = point
	
	tail.points = tail_points


# Body Visuals & Audio
@onready var model: CanvasGroup = $Model
@onready var _body: AnimatedSprite2D = $Model/Body
@onready var _center: Sprite2D = $Model/Center
func _process_visuals(delta: float) -> void: 
	if dead: return
	
	var angle := get_angle_to(get_global_mouse_position())
	_body.rotation = LerpHelper.la(_body.rotation, angle, 16.0, delta)
	_center.rotation = LerpHelper.la(_center.rotation, angle, 4.0, delta)

const _RICOCHET_AUDIOS := [preload("uid://c0xfowxnk65ro"), preload("uid://cgev1lhy8m65c"), preload("uid://d2i8mrtm6x368")]
const _KILL_AUDIOS := [preload("uid://cw51rnwwiauia"),preload("uid://ch76w0ku3btqh")]
func play_kill_audio() -> void:
	$KillSoundPlayer.stream = _KILL_AUDIOS[randi_range(0,1)]
	$KillSoundPlayer.pitch_scale = randf_range(0.9, 1.1)
	$KillSoundPlayer.play()

func level_completed() -> void:
	velocity = Vector2.ZERO
	momentum = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(model, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(model, "position:y", model.position.y - 33, 0.35).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


# Grabber
@onready var grabber: Area2D = $Model/Grabber
func _process_grabber() -> void: # Anchors and rotates the grabber based off of the tail
	var last_point := tail_points[tail_points.size()-1]
	grabber.position = last_point
	grabber.rotation = last_point.angle()
	for area in grabber.get_overlapping_areas():
		if area is Interactable: area.interact()


# Grappling
var grapple_direction: Vector2
var retracting_tail := false
var attempting_to_grapple := false
var grappled_object: Node2D
@onready var grapple_direction_indicator: Polygon2D = $GrappleDirectionIndicator
func _process_grappling(delta: float) -> void:
	if !dead: _process_grapple_controls()
	if !grappled_object: 
		if attempting_to_grapple: # Attempting grapple
			target_tail_dist = GRAPPLING_TAIL_DIST
			for body in grabber.get_overlapping_bodies():
				if body is StaticBody2D:
					attempting_to_grapple = false
			for area in grabber.get_overlapping_areas():
				if area is GrapplePoint:
					hit_grapple(area)
		else:
			if retracting_tail: 
				target_tail_dist = RETRACTED_TAIL_DIST
				tail_dist = RETRACTED_TAIL_DIST
			else:               target_tail_dist = DEFAULT_TAIL_DIST
		return
	
	tail_points[tail_points.size()-1] = grappled_object.global_position - global_position
	tail_dist = global_position.distance_to(grappled_object.global_position)*0.09
	target_tail_dist = global_position.distance_to(grappled_object.global_position)*0.09
	momentum += global_position.direction_to(grappled_object.global_position) * 3000.0 * delta

func _process_grapple_controls() -> void:
	if !grappled_object:
		if Input.is_action_pressed("grapple") and !attempting_to_grapple: # Grapple slow-down
			retracting_tail = true
			GameTime.set_temp_scale(0.1)
			grapple_direction_indicator.look_at(get_global_mouse_position())
			grapple_direction_indicator.show()
		elif Input.is_action_just_released("grapple") and !attempting_to_grapple: # Grapple shoot
			retracting_tail = false
			grapple_direction = global_position.direction_to(get_global_mouse_position())
			grapple_direction_indicator.hide()
			$GrappleSoundPlayer.pitch_scale = randf_range(0.75, 1.25)
			$GrappleSoundPlayer.play()
			attempting_to_grapple = true
			$GrappleTimer.start(0.5)

func hit_grapple(node: Node2D) -> void:
	#print("Grappled " + node.name + "!")
	momentum = Vector2.ZERO
	velocity = Vector2.ZERO
	grappled_object = node
	attempting_to_grapple = false

func release_grapple() -> void:
	#print("Released grappled object!")
	grappled_object = null

func passed_grapple_object() -> void:
	if !grappled_object: return
	grappled_object = null
	momentum *= 2


func _on_grapple_timer_timeout() -> void:
	if grappled_object: return
	attempting_to_grapple = false


# Death
signal died
var dead := false

func die(reason := "") -> void:
	if dead: return
	
	dead = true
	if reason == "Pit":
		var tween := create_tween()
		tween.tween_property(model, "scale", Vector2(.001, .001), 0.385).set_trans(Tween.TRANS_EXPO)
		tween.tween_callback(died.emit)
		$DeathSoundPlayer.pitch_scale = randf_range(0.8, 1.2)
		$DeathSoundPlayer.stream = preload("uid://prsawxmrh7wt")
		$DeathSoundPlayer.play()
	else:
		var tween := create_tween()
		tween.tween_property(model, "scale:y", 0.001, 0.33).set_trans(Tween.TRANS_EXPO)
		tween.parallel().tween_property(model, "scale:x", 0.001, 0.5).set_trans(Tween.TRANS_EXPO)
		$DeathSoundPlayer.pitch_scale = randf_range(0.8, 1.2)
		$DeathSoundPlayer.play()
		died.emit()

func bleed(angle: float) -> void:
	if dead: return
	
	$NotBloodParticles.rotation = angle
	$NotBloodParticles.restart()
