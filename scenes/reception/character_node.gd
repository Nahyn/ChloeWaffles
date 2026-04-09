extends Control
class_name CharacterNode

@onready var texture_rect: TextureRect = $TextureRect

@onready var bubble_positionner: Control = %BubblePositionner
@onready var phase_timer: PhaseTimer = %PhaseTimer

var bubble_movement_tween :Tween;
var bubble_target_position := Vector2(0.0, 0.0);
@export var bubble_movement_duration := 2.0;
@export var bubble_movement_range := 20.0;

@export var character_resource :CharacterResource

func _ready() -> void:
	_arrived.call_deferred()

func _process(_delta: float) -> void:
	if (%BubblePositionner.position - bubble_target_position).length_squared() < 1.0:
		generate_new_bubble_position()

func generate_new_bubble_position() -> void:
	if bubble_movement_tween != null:
		bubble_movement_tween.kill();
	bubble_target_position = Vector2(randf_range(-100.0, 100.0), randf_range(-100.0, 100.0)).normalized() * bubble_movement_range;
	bubble_movement_tween = create_tween();
	bubble_movement_tween.set_ease(Tween.EASE_IN_OUT);
	bubble_movement_tween.tween_property(%BubblePositionner, "position", bubble_target_position, bubble_movement_duration);

func get_ordered_waffle() -> WaffleNode:
	return %WaffleNode

func generate_waffle() -> void:
	if character_resource == null:
		return
	
	%WaffleNode.create_from_ingredients(character_resource.get_random_order())

func _arrived() -> void:
	%ThoughBubble.visible = true;
	%QuestionPositionner.visible = true;
	%WafflePositionner.visible = false;
	if character_resource != null and character_resource.sprite != null:
		texture_rect.texture = character_resource.sprite
		%BubbleAnchor.position.y = character_resource.though_bubble_y
	name = str("CharacterNode_", character_resource.name);
	generate_waffle();
	phase_timer.start_timer();
	SoundManager.play_entry_sound(global_position);

func has_order_visible() -> bool:
	return %WafflePositionner.visible;

func show_order() -> void:
	%QuestionPositionner.visible = false;
	%WafflePositionner.visible = true;

func _leaving() -> void:
	EventManager.client_leaving.emit(self);
	%ThoughBubble.visible = false;
	%ThoughBackgroundParticles.visible = false;
	%PomfParticles.emitting = true;
	await %PomfParticles.finished;
	SoundManager.play_exit_sound(global_position);
	queue_free();

func _on_phase_timer_failed() -> void:
	prints("_on_phase_timer_failed", character_resource.name);
	EventManager.client_missed.emit();
	_leaving();

func _on_mouse_click_area_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		EventManager.client_clicked.emit(self)


func _on_mouse_click_area_mouse_entered() -> void:
	%AnimationPlayer.play("on_hover")


func _on_mouse_click_area_mouse_exited() -> void:
	pass # Replace with function body.
