@tool class_name RichTextDescent extends RichTextEffect


var bbcode := "descent"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var distance: float = char_fx.env.get("distance", 2.0)
	char_fx.transform = char_fx.transform.translated(Vector2(0.0, char_fx.relative_index*distance))
	
	return true
