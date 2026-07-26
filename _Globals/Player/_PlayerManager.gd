extends Node


var easy_mode := false
var player: Player
func add_player(parent: Node = get_tree().get_root()) -> void:
	if player: player.queue_free()
	player = preload("uid://fr8karxanqon").instantiate()
	parent.add_child(player, true)
	if parent is Level:
		player.global_position = parent.get_player_spawn_point()
