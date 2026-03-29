extends Node2D
class_name GameScreen

@onready var camera_2d: Camera2D = $Camera2D
var screen_size := Vector2(1920, 1080);


func _on_waffle_maker_screen_go_screen_left() -> void:
	camera_2d.position.x -= screen_size.x
	pass # Replace with function body.


func _on_assembly_screen_go_screen_up() -> void:
	camera_2d.position.y -= screen_size.y
	pass # Replace with function body.


func _on_assembly_screen_go_screen_right() -> void:
	camera_2d.position.x += screen_size.x


func _on_reception_screen_go_screen_down() -> void:
	camera_2d.position.y += screen_size.y
