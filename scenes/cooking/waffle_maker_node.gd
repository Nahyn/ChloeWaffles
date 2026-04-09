extends Control
class_name WaffleMakerNode

const WAFFLE_BURNED = preload("uid://ccvaarlbw0asy")

const FAILURE_PARTICLES = preload("uid://bc3448o1tiw3d")
const SUCCESS_PARTICLES = preload("uid://d0o4t5a6xpjba")
@onready var failure_particles: CPUParticles2D = $TextureRect/FailureParticles

signal waffle_finished(ingredient_resource :IngredientResource, multiplier :float)
signal on_failure()

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var phase_timer: PhaseTimer = %PhaseTimer


var current_ingredient_resource :IngredientResource
var current_phase :PhaseTimerSegmentResource;

func _ready() -> void:
	_initialiaze.call_deferred();

func _initialiaze() -> void:
	if failure_particles == null:
		return
	%WaffleStockpile.visible = false;
	failure_particles.emitting = false;
	phase_timer.visible = false;
	phase_timer.reset();

func toggle_lid() -> void:
	if phase_timer.is_running() or phase_timer.has_failed:
		open_lid();
	elif %WaffleStockpile.is_batter():
		close_lid();

func _on_failure() -> void:
	on_failure.emit()
	failure_particles.emitting = true;


func put_batter( waffle_ingredient :WaffleIngredientResource ) -> void:
	if %WaffleStockpile.visible == true:
		return;
	%WaffleStockpile.visible = true;
	%WaffleStockpile.ingredient = waffle_ingredient;
	%WaffleStockpile.texture = waffle_ingredient.batter_texture;
	SoundManager.play_splat_sound(global_position)
	phase_timer.reset();

func hide_waffle() -> void:
	%WaffleStockpile.visible = false;

func open_lid() -> void:
	animation_player.play("open");
	phase_timer.visible = false;
	phase_timer.stop_timer()
	
	%WaffleStockpile.visible = true;
	var waffle_multiplier = %WaffleStockpile.multiplier
	
	if %WaffleStockpile.is_batter():
		return
	
	var tmp_particles := SUCCESS_PARTICLES.instantiate() as CustomParticleSystem
	if phase_timer.has_failed:
		SoundManager.stop_looping_alarm_sound(global_position)
		%WaffleStockpile.ingredient = WAFFLE_BURNED
		tmp_particles = FAILURE_PARTICLES.instantiate() as CustomParticleSystem
		waffle_multiplier = -2.0
	failure_particles.emitting = false;
	
	tmp_particles.global_position = phase_timer.global_position - global_position
	add_child(tmp_particles)
	SoundManager.play_pop_sound(global_position);
	
	await animation_player.animation_finished
	waffle_finished.emit(%WaffleStockpile.ingredient, waffle_multiplier);
	%WaffleStockpile.visible = false;


func close_lid() -> void:
	if %WaffleStockpile.visible == false:
		return
	
	animation_player.play("close")
	phase_timer.visible = true;
	%WaffleStockpile.visible = false;
	phase_timer.start_timer();

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()):
		return
	
	event = event as InputEventMouseButton
	if event.button_index == MOUSE_BUTTON_LEFT:
		toggle_lid()


func _on_timer_phases_container_phase_started(phase: PhaseTimerSegmentResource) -> void:
	current_phase = phase;
	if phase.multiplier > 0:
		%WaffleStockpile.texture = %WaffleStockpile.ingredient.stockpile_texture
	
	if phase_timer.phases[phase_timer.phases.size()-1] == current_phase:
		SoundManager.play_alarm_sound(global_position);

func _on_timer_phases_container_failed() -> void:
	on_failure.emit()
	SoundManager.play_looping_alarm_sound(global_position)
	phase_timer.visible = false;
	failure_particles.emitting = true;
	EventManager.waffle_burnt.emit()
