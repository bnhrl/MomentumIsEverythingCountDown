class_name EntityBacteriophage extends Entity


const BLOOD_COLORS : Dictionary[int, Color] = {
	0: Color("f04f78"),
	1: Color("a884f3"),
	2: Color("4d9be6"),
	3: Color("30e1b9"),
	4: Color("91db69"),
	5: Color("a2a947"),
	6: Color("f79617"),
	7: Color("ae2334"),
}

func _ready() -> void:
	super._ready()
	var variant := randi_range(0,7)
	sprite.play("default_"+str(variant))
	blood_color = BLOOD_COLORS.get(variant)
	wall_raycast.show()
	wall_raycast.rotation = randf_range(-PI, PI)
	wall_raycast.force_raycast_update()
	await get_tree().physics_frame
	await get_tree().physics_frame
	if wall_raycast.is_colliding():
		global_position = wall_raycast.get_collision_point()
	

@onready var wall_raycast: RayCast2D = $WallRaycast
var wall_direction := 1
var time_away_from_wall := 1.0
var knockback := Vector2.ZERO
func _process_movement(delta: float) -> void:
	if is_on_wall():
		time_away_from_wall = 1.0
		direction = get_wall_normal().rotated(PI * 0.5 * wall_direction)
		if redirect_timer.is_stopped():
			redirect_timer.start(randf_range(2, 4))
			wall_direction = randi_range(-1, 1)
	else:
		time_away_from_wall += delta
		if wall_raycast.is_colliding():
			direction = global_position.direction_to(wall_raycast.get_collision_point())
		else:
			wall_raycast.rotation += delta
	
	for i in range(get_slide_collision_count()):
		var collider := get_slide_collision(i).get_collider()
		if collider and collider is PhageSmacker:
			knockback += collider.momentum
			wall_raycast.rotation = knockback.angle()
	
	var target_velocity := direction * speed * delta * time_away_from_wall
	velocity = LerpHelper.lv2(velocity, target_velocity, 8.0, delta) + knockback
	knockback = LerpHelper.lv2(knockback, Vector2.ZERO, 3.33, delta)


@onready var sprite: AnimatedSprite2D = $Model/Sprite
func _process_visuals(delta: float) -> void:
	if is_on_wall():
		model.rotation = LerpHelper.la(model.rotation, get_wall_normal().angle() + PI, 12.0, delta)
	else:
		model.rotation += delta * velocity.length() * 0.25
