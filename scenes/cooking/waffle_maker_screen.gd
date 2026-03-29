extends Control
class_name WaffleMakerScreen

signal go_screen_left()

func _on_go_left_button_pressed() -> void:
	go_screen_left.emit()
