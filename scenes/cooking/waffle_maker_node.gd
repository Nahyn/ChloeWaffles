extends Control

@export var SUCCESS_SOUND :AudioStream
@export var FAILURE_SOUND :AudioStream
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const FAILURE_PARTICLES = preload("uid://bc3448o1tiw3d")
const SUCCESS_PARTICLES = preload("uid://d0o4t5a6xpjba")
@onready var failure_particles: CPUParticles2D = $TextureRect/FailureParticles

signal on_failure()
signal on_opened( ingredient_resource :IngredientResource, multiplier :float )
signal on_success( ingredient_resource :IngredientResource, multiplier :float )

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var phase_timer: PhaseTimer = %PhaseTimer

var current_ingredient_resource :IngredientResource
var current_phase :PhaseTimerSegmentResource;

func _ready() -> void:
	_initialiaze.call_deferred();

func _initialiaze() -> void:
	if failure_particles == null:
		return
	failure_particles.emitting = false;
	phase_timer.visible = false;
	phase_timer.reset();

func toggle_timer() -> void:
	if phase_timer.is_running() or phase_timer.has_failed:
		open_lid();
		phase_timer.reset();
	else:
		close_lid();

func _on_failure() -> void:
	on_failure.emit()
	failure_particles.emitting = true;

func _on_success() -> void:
	on_success.emit(current_ingredient_resource, current_phase.multiplier)


func open_lid() -> void:
	animation_player.play("open");
	phase_timer.visible = false;
	var phase_multiplier := current_phase.multiplier;
	
	var tmp_particles := SUCCESS_PARTICLES.instantiate() as CustomParticleSystem
	var tmp_sound := SUCCESS_SOUND
	if phase_timer.has_failed:
		tmp_particles = FAILURE_PARTICLES.instantiate() as CustomParticleSystem
		tmp_sound = FAILURE_SOUND
		phase_multiplier = -2.0
	
	failure_particles.emitting = false;
	on_opened.emit(current_ingredient_resource, phase_multiplier);
	
	tmp_particles.global_position = phase_timer.global_position - global_position
	add_child(tmp_particles)
	audio_stream_player_2d.stream = tmp_sound;
	audio_stream_player_2d.play();


func close_lid() -> void:
	animation_player.play("close")
	phase_timer.visible = true;
	phase_timer.start_timer();

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()):
		return
	
	event = event as InputEventMouseButton
	if event.button_index == MOUSE_BUTTON_LEFT:
		toggle_timer()


func _on_timer_phases_container_phase_started(phase: PhaseTimerSegmentResource) -> void:
	current_phase = phase;

func _on_timer_phases_container_failed() -> void:
	on_failure.emit()
	phase_timer.visible = false;
	failure_particles.emitting = true;
