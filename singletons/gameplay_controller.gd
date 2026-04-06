extends Node

enum GAMEMODES {
	STORY,
	FREEMODE
}

enum DAY_PHASES {
	START,
	GAMEPLAY,
	END
}

@export var day_list :Array[DayResource] = []
@export var default_day_resource :GameplayDayResouce

var current_day := 0;
var current_phase :DAY_PHASES = -1
var current_gamemode :GAMEMODES
var last_gameplay_data :GameplayDayResouce

func _ready() -> void:
	Dialogic.timeline_ending.connect(_on_vn_ending);
	Dialogic.timeline_ended.connect(progress_story);

func story_complete() -> bool:
	return (current_day >= day_list.size());

func _on_vn_ending() -> void:
	SceneManager._show_between_screen()

func _on_vn_ended() -> void:
	progress_story()

func start_freegame() -> void:
	current_gamemode = GAMEMODES.FREEMODE
	last_gameplay_data = default_day_resource
	SceneManager.load_gameplay(default_day_resource);

func start_story() -> void:
	current_day = 0;
	current_phase = 0;
	current_gamemode = GAMEMODES.STORY
	_go_to_next_story_scene();

func start_ending() -> void:
	SceneManager.go_to_main_menu()

func retry_gameplay() -> void:
	SceneManager.load_gameplay(last_gameplay_data);

func next_screen() -> void:
	match current_gamemode:
		GAMEMODES.STORY:
			progress_story()
		GAMEMODES.FREEMODE:
			start_ending()

func progress_story() -> void:
	current_phase += 1
	if current_phase >= DAY_PHASES.size():
		current_phase = 0
		current_day += 1
	
	if story_complete():
		start_ending()
		return
	
	_go_to_next_story_scene()

func _go_to_next_story_scene() -> void:
	var current_day_data = day_list[current_day];
	
	match current_phase:
		DAY_PHASES.START:
			SceneManager.load_vn(current_day_data.opening_timeline)
		DAY_PHASES.GAMEPLAY:
			last_gameplay_data = current_day_data.gameplay_day_data
			SceneManager.load_gameplay(current_day_data.gameplay_day_data);
		DAY_PHASES.END:
			SceneManager.load_vn(current_day_data.closing_timeline)
	
