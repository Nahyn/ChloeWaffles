@tool
extends Node
class_name TimerNode

signal phase_started(phase_index :int)
signal timer_finished()

@export var timer_limits :Array[float] = []
@export var speed := 1.0;

var running := false;

var total_limits := 0.0;
var total_duration := 0.0;

var current_phase_index := 0;
var current_phase_duration := 0.0;

func _ready() -> void:
	_initialiaze.call_deferred();

func _initialiaze() -> void:
	total_limits = 0.0;
	for timer_limit in timer_limits:
		total_limits += timer_limit;
	
	reset();

func reset():
	current_phase_index = 0;
	current_phase_duration = 0.0;
	total_duration = 0.0;
	running = false;

func start_timer() -> void:
	running = true;
	phase_started.emit(0);

func pause_timer() -> void:
	running = false;

func _process(delta: float) -> void:
	if not running:
		return;
	
	var time_increment = delta * speed;
	total_duration += time_increment;
	if total_duration >= total_limits:
		timer_finished.emit();
		running = false;
		return;
	
	current_phase_duration += time_increment;
	if current_phase_duration > timer_limits[current_phase_index]:
		current_phase_duration -= timer_limits[current_phase_index]
		current_phase_index += 1;
		phase_started.emit(current_phase_index);

func set_limits( phases :Array[PhaseTimerSegmentResource] ) -> void:
	timer_limits.clear();
	for phase in phases:
		if phase == null:
			continue
		timer_limits.push_back(phase.duration);
	
	_initialiaze();
	

func get_duration_ratio() -> float:
	if total_limits == 0.0:
		_initialiaze();
		if total_limits == 0.0:
			return 0.5;
	
	return total_duration/total_limits

func get_limit_ratios() -> Array[float]:
	var ratios :Array[float] = [];
	
	if total_limits == 0.0:
		_initialiaze();
		if total_limits == 0.0:
			return ratios;
	
	for timer_limit in timer_limits:
		ratios.push_back(timer_limit / total_limits)
	
	return ratios;
