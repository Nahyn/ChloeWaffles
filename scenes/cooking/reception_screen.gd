extends Control
class_name ReceptionScreen

signal go_screen_down()

func _on_go_down_button_pressed() -> void:
	go_screen_down.emit();
