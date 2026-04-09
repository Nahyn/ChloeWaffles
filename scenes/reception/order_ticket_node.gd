extends Control
class_name OrderTicketNode

const PHASE_TIMER = preload("uid://dqt1bsryg2t3u")

var waffle_ordered :WaffleNode

var ingredient_margin_default := -20.0;
var max_ingredient_margin_hovered := -300.0;
var ingredient_margin_hovered := max_ingredient_margin_hovered;

var height_default := 300.0;
var height_hovered := 800.0;

var local_tween :Tween
@export var tween_duration := 0.2;

func _ready() -> void:
	randomize_appearance.call_deferred();

func randomize_appearance() -> void:
	rotation_degrees = randf_range(-2.0, 2.0);
	
	height_default = randf_range(250.0, 350.0);
	set_hovered.call_deferred(false);

func initialize_timer( timer :PhaseTimer ) -> void:
	var copied_timer = PHASE_TIMER.instantiate() as PhaseTimer;
	copied_timer.name = "OrderTicketTimer";
	copied_timer.copy_timer.call_deferred(timer);
	%TimerPositionner.add_child(copied_timer);

func initialize_waffle( order :WaffleNode ) -> void:
	waffle_ordered = order;
	var ingredient_list := order.get_ingredients()
	%WaffleNode.create_from_ingredients(ingredient_list);
	ingredient_margin_hovered = max(max_ingredient_margin_hovered, -800 / float(ingredient_list.size())) 

func set_hovered( is_hovered :bool ) -> void:
	if local_tween != null:
		local_tween.kill()
	
	var target_height = height_default;
	var target_ingredient_margin = ingredient_margin_default;
	var target_z_index = 0;
	
	if is_hovered:
		target_height = height_hovered;
		target_ingredient_margin = ingredient_margin_hovered;
		target_z_index = 3;
	
	local_tween = create_tween()
	local_tween.parallel().tween_property(%ContainerMask, "size:y", target_height, tween_duration)
	local_tween.parallel().tween_property(%ContainerMask, "z_index", target_z_index, tween_duration)
	local_tween.parallel().tween_property(%WaffleNode, "ingredient_margin", target_ingredient_margin, tween_duration)

func _on_overlay_mouse_entered() -> void:
	set_hovered(true)

func _on_overlay_mouse_exited() -> void:
	set_hovered(false)
