extends Node


func wait(time: float) -> Signal:
	return get_tree().create_timer(time, false).timeout

func pause(time: float) -> Signal:
	return get_tree().create_timer(time, true).timeout
