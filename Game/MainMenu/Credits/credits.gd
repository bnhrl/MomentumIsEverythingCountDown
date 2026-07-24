extends Control

@onready var buttons: Array[UIButton] = [$BtnBnhrl, $BtnCatJug, $BtnCuptain]
func _ready() -> void:
	buttons.shuffle()
	for i in range(buttons.size()):
		buttons[i].position.y = 124.0 + 55*i
	var tween := create_tween()
	tween.tween_property(self, "scale:y", 1.0, 0.5).set_trans(Tween.TRANS_ELASTIC).from(0)

var closed := false
func close() -> void:
	if closed: return
	var tween := create_tween()
	tween.tween_property(self, "scale:y", 0.0, 0.5).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(queue_free)


func _on_btn_bnhrl_pressed() -> void:
	open_page("https://bnhrl.itch.io/")

func _on_btn_cat_jug_pressed() -> void:
	open_page("https://cat-jug.itch.io/")

func _on_btn_cuptain_pressed() -> void:
	open_page("https://chiefcuptain.itch.io/")

func open_page(page: String) -> void:
	var i := randi_range(0,99)
	if i == 0: page = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
	OS.shell_open(page)

func _on_btn_close_pressed() -> void:
	close()
