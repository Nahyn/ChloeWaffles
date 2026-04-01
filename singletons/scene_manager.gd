extends Node

enum SCREEN_TYPES {
	GAME, MAIN_MENU
}

var SCENE_PATHS :Dictionary = {
	GAME = "res://scenes/game_sceen.tscn",
	MAIN_MENU = "res://scenes/main_menu.tscn"
}

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

func load_screen( screen_type :SCREEN_TYPES ) -> void:
	var screen_name = SCREEN_TYPES.find_key(screen_type);
	
	if not SCENE_PATHS.has(screen_name):
		return
	
	var screen_path = SCENE_PATHS[screen_name]
	_show_between_screen()
	
	await animation_player.animation_finished
	get_tree().change_scene_to_file(screen_path);
	await get_tree().scene_changed;
	
	_hide_between_screen()

func _show_between_screen() -> void:
	animation_player.play("fade_in")
func _hide_between_screen() -> void:
	animation_player.play("fade_out")
