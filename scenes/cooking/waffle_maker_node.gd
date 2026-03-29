extends Control

@export var SUCCESS_SOUND :AudioStream
@export var FAILURE_SOUND :AudioStream
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const FAILURE_PARTICLES = preload("uid://bc3448o1tiw3d")
const SUCCESS_PARTICLES = preload("uid://d0o4t5a6xpjba")

signal on_failure()
signal on_success( ingredient_resource :IngredientResource, multiplier :float )

@onready var timer_node: TimerNode = $TimerNode
@onready var timer_phases_container: Control = %TimerPhasesContainer
@onready var phase_indicator_progress_bar: TextureProgressBar = %PhaseIndicatorProgressBar
@onready var current_timer_texture_progress_bar: TextureProgressBar = %CurrentTimerTextureProgressBar

@export var phases : Array[TimerPhaseResource] = [];
var _phases_progressbars :Dictionary[TimerPhaseResource, TextureProgressBar] = {}

var current_ingredient_resource :IngredientResource
var current_phase_index := 0;

func _ready() -> void:
	_initialiaze.call_deferred();

func _initialiaze() -> void:
	if timer_phases_container == null:
		return;
	
	if phases.size() > 0:
		_phases_progressbars[phases[0]] = phase_indicator_progress_bar;
	timer_node.set_limits(phases)
	
	var current_starting_duration = 0.0;
	for phase in phases:
		var current_progressbar :TextureProgressBar
		
		if not _phases_progressbars.has(phase):
			current_progressbar = phase_indicator_progress_bar.duplicate();
			timer_phases_container.add_child(current_progressbar);
			timer_phases_container.move_child(current_progressbar, 1);
			_phases_progressbars[phase] = phase_indicator_progress_bar
		
		current_progressbar = _phases_progressbars[phase]
		current_progressbar.tint_progress = phase.tint;
		current_progressbar.radial_initial_angle = (current_starting_duration / timer_node.total_limits) * 360.0;
		current_progressbar.value = phase.duration / timer_node.total_limits;
		current_starting_duration += phase.duration;
	
	current_timer_texture_progress_bar.move_to_front.call_deferred()

func _process(_delta: float) -> void:
	if timer_node.running:
		current_timer_texture_progress_bar.value = timer_node.get_duration_ratio();

func get_current_phase() -> TimerPhaseResource:
	var current_phase :TimerPhaseResource = phases[current_phase_index];
	return current_phase;

func toggle_timer() -> void:
	if timer_node.running:
		timer_node.pause_timer()
		if current_phase_index == 0:
			_on_failure()
			return
		_on_success();
	else:
		timer_node.start_timer()


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()):
		return
	
	event = event as InputEventMouseButton
	if event.button_index == MOUSE_BUTTON_LEFT:
		toggle_timer()


func _on_timer_node_phase_started(phase_index: int) -> void:
	current_phase_index = phase_index;
	prints("_on_timer_node_phase_starts");
	get_current_phase()


func _on_timer_node_timer_finished() -> void:
	current_phase_index = 0;
	current_timer_texture_progress_bar.value = 0.0;
	_on_failure();

func _on_failure() -> void:
	on_failure.emit()
	var tmp_particles = FAILURE_PARTICLES.instantiate() as CustomParticleSystem
	tmp_particles.global_position = timer_phases_container.global_position - global_position
	add_child(tmp_particles)
	audio_stream_player_2d.stream = FAILURE_SOUND;
	audio_stream_player_2d.play();

func _on_success() -> void:
	var current_phase := get_current_phase();
	on_success.emit(current_ingredient_resource, current_phase.multiplier)
	
	var tmp_particles = SUCCESS_PARTICLES.instantiate() as CustomParticleSystem
	tmp_particles.amount = current_phase.multiplier * 10;
	tmp_particles.global_position = timer_phases_container.global_position - global_position
	add_child(tmp_particles)
	audio_stream_player_2d.stream = SUCCESS_SOUND;
	audio_stream_player_2d.play();
	
	current_phase_index = 0;
	current_timer_texture_progress_bar.value = 0.0;
