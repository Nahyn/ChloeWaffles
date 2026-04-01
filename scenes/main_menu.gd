extends Control
class_name MainMenuScreen

func load_game() -> void:
	SceneManager.load_screen(SceneManager.SCREEN_TYPES.GAME);

func reload_scene() -> void:
	SceneManager.load_screen(SceneManager.SCREEN_TYPES.MAIN_MENU);


func _on_reload_button_pressed() -> void:
	reload_scene()

func _on_game_button_pressed() -> void:
	load_game()
