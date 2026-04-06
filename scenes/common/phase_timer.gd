@tool
extends Control
class_name PhaseTimer

signal phase_started( phase :PhaseTimerSegmentResource )
signal failed()

@onready var progress_bar_container: Control = $ProgressBarContainer
@onready var background_timer_texture_rect: TextureRect = %BackgroundTimerTextureRect
@onready var phase_indicator_progress_bar: TextureProgressBar = %PhaseIndicatorProgressBar
@onready var current_timer_texture_progress_bar: TextureProgressBar = %CurrentTimerTextureProgressBar

@export var progress_fill_mode :TextureProgressBar.FillMode = TextureProgressBar.FillMode.FILL_CLOCKWISE
@onready var timer_node: TimerNode = %TimerNode


@export var background_texture :Texture2D:
	set(_texture):
		background_texture = _texture
		_update_textures()
@export var progress_texture :Texture2D:
	set(_texture):
		progress_texture = _texture
		_update_textures()
@export var over_texture :Texture2D:
	set(_texture):
		over_texture = _texture
		_update_textures()

@export var phases :Array[PhaseTimerSegmentResource] = []:
	set(_phases):
		phases = _phases
		_initialize()

@export_tool_button("Update_progress_bars") var update_progress_bar_action = _initialize

var has_failed := false

func _ready() -> void:
	_initialize.call_deferred();

func _update_textures() -> void:
	if background_timer_texture_rect == null:
		return
	background_timer_texture_rect.texture = background_texture
	phase_indicator_progress_bar.texture_progress = progress_texture
	current_timer_texture_progress_bar.texture_progress = progress_texture
	current_timer_texture_progress_bar.texture_over = over_texture

func copy_timer( phase_timer :PhaseTimer ) -> void:
	prints("copy_timer", name)
	phases.clear()
	for phase in phase_timer.phases:
		phases.push_back(phase)
	
	for timer_attribute in ["running", "current_phase_duration", "current_phase_index", "total_duration"]:
		timer_node[timer_attribute] = phase_timer.timer_node[timer_attribute]

func _initialize() -> void:
	if progress_bar_container == null or phases.size() == 0:
		return
	_update_textures();
	prints("_initialize", name)
	for progress_bar in progress_bar_container.get_children():
		if [background_timer_texture_rect, phase_indicator_progress_bar, current_timer_texture_progress_bar].has(progress_bar):
			continue;
		progress_bar.queue_free()
	
	timer_node.set_limits(phases)
	
	var current_starting_duration = 0.0;
	for phase_index in phases.size():
		var tmp_phase = phases[phase_index]
		
		if tmp_phase == null:
			continue
		
		var current_progressbar :TextureProgressBar
		if phase_index == 0:
			current_progressbar = phase_indicator_progress_bar
		else:
			current_progressbar = phase_indicator_progress_bar.duplicate();
			progress_bar_container.add_child(current_progressbar);
		
		current_progressbar.fill_mode = progress_fill_mode;
		progress_bar_container.move_child(current_progressbar, 1);
		current_progressbar.tint_progress = tmp_phase.tint;
		current_progressbar.radial_initial_angle = (current_starting_duration / timer_node.total_limits) * 360.0;
		current_progressbar.value = tmp_phase.duration / timer_node.total_limits;
		current_starting_duration += tmp_phase.duration;
	
	progress_bar_container.move_child(background_timer_texture_rect, 0);
	current_timer_texture_progress_bar.move_to_front()

func reset() -> void:
	current_timer_texture_progress_bar.value = 0.0;
	has_failed = false;
	timer_node.reset();

func start_timer() -> void:
	prints("start_timer", name)
	current_timer_texture_progress_bar.value = 0.0;
	timer_node.start_timer();

func stop_timer() -> void:
	prints("stop_timer", name)
	timer_node.pause_timer();
	current_timer_texture_progress_bar.value = 0.0;

func get_current_phase() -> PhaseTimerSegmentResource:
	return phases[timer_node.current_phase_index];

func is_running() -> bool:
	return timer_node.running;

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if timer_node.running:
		current_timer_texture_progress_bar.value = timer_node.get_duration_ratio() * current_timer_texture_progress_bar.max_value;

func _on_timer_node_phase_started(phase_index: int) -> void:
	phase_started.emit(phases[phase_index]);

func _on_timer_node_timer_finished() -> void:
	has_failed = true;
	failed.emit();
