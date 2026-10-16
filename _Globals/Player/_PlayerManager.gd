extends Node


var easy_mode := true
var player: Player
var player_added_to_scene := false
func add_player(parent: Node = get_tree().get_root()) -> void:
	if player: player.queue_free()
	player = preload("uid://fr8karxanqon").instantiate()
	parent.add_child(player, true)
	if parent is Level:
		player.global_position = parent.get_player_spawn_point()
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		player_added_to_scene = true
