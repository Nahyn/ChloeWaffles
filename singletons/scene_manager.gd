extends Node

signal scene_hidden
signal scene_shown

enum SCREEN_TYPES {
	GAME, 
	MAIN_MENU, 
	VN
}

var SCENE_PATHS :Dictionary = {
	GAME = "res://scenes/game_sceen.tscn",
	MAIN_MENU = "res://scenes/main_menu.tscn",
	VN = "res://scenes/vn_screen.tscn"
}

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

func _show_between_screen() -> void:
	if %DropoutColorRect.visible:
		animation_player.animation_finished.emit()
		await animation_player.animation_finished
		scene_hidden.emit()
		return
	animation_player.play("fade_in")

func _hide_between_screen() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	scene_shown.emit()

func go_to_main_menu() -> void:
	load_screen(SCREEN_TYPES.MAIN_MENU);

func load_vn( timeline :DialogicTimeline ) -> void:
	var vn_scene = await load_screen(SCREEN_TYPES.VN) as DialogScene;
	vn_scene.dialogic_timeline = timeline;
	vn_scene.start_timeline.call_deferred();

func load_gameplay( gameplay_data :GameplayDayResouce ) -> void:
	var game_scene = await load_screen(SCREEN_TYPES.GAME) as GameScreen;
	game_scene.initialize(gameplay_data);

func load_screen( screen_type :SCREEN_TYPES ) -> Node:
	var screen_name = SCREEN_TYPES.find_key(screen_type);
	
	if not SCENE_PATHS.has(screen_name):
		return
	
	var screen_path = SCENE_PATHS[screen_name]
	_show_between_screen()
	
	await animation_player.animation_finished
	get_tree().change_scene_to_file(screen_path);
	await get_tree().scene_changed;
	_hide_between_screen.call_deferred()
	return get_tree().current_scene
