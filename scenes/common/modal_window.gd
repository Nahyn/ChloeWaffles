@tool
extends Control
class_name ModalWindow

@export var title := "[MODAL_WINDOW]":
	set(_title):
		title = _title
		%TitleLabel.text = title


func _on_close_button_pressed() -> void:
	prints("_on_close_button_pressed")
	visible = false;
