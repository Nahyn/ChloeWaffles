extends Node2D
class_name GameScreen

@onready var selected_item_control: SelectedItemControl = %SelectedItemControl
@onready var camera_2d: Camera2D = $Camera2D
var screen_size := Vector2(1920, 1080);

const SCORE_LABEL = preload("uid://dcu1mgvn7ko8r")

@export_group("Score by", "score_by")
@export var score_by_valid_ingredient := 20
@export var score_by_missing_ingredient := -20
@export var score_by_unwanted_ingredient := -20
@export var score_by_overloaded_ingredient := -10

@export var score_by_missed_client := -100
@export var score_by_trashed_ingredient := -30
@export var score_by_burned_waffle := -30

@export var reception_waffle_scale := 0.5;
@export var waffle_sending_duration := 0.5;
@export var reception_waffle_slots :Array[Control] = []

var current_time
var current_score := 0;

var score_objective := 0
var time_lime := 20

func _ready() -> void:
	EventManager.client_served.connect(_on_client_served)
	EventManager.client_missed.connect(_on_client_missed)
	EventManager.client_clicked.connect(_on_client_clicked)
	EventManager.trash_clicked.connect(_on_trash_clicked)
	EventManager.waffle_trashed.connect(_on_waffle_trashed)
	EventManager.bell_clicked.connect(_on_bell_clicked)
	EventManager.waffle_burnt.connect(_on_waffle_burnt)
	EventManager.waffle_clicked.connect(_on_waffle_clicked)
	EventManager.stockpile_clicked.connect(_on_stockpile_clicked)

func change_score( _modifier :int ) -> void:
	current_score += _modifier
	%ScoreLabel.text = str(current_score);
	
	var modifier_label := SCORE_LABEL.instantiate() as ScoreLabel;
	var modifier_str = str(_modifier);
	var modifier_color = Color(0.741, 0.118, 0.0, 1.0);
	if _modifier > 0:
		modifier_str = str("+", modifier_str);
		modifier_color = Color(0.208, 0.541, 0.243, 1.0);
	modifier_label.text = modifier_str
	modifier_label.set_outline_color(modifier_color)
	
	var score_position = %ScoreLabel.global_position
	var modifier_position = Vector2.ZERO;
	modifier_position.x = score_position.x + %ScoreLabel.size.x * randf_range(0.1, 0.9);
	modifier_position.y = score_position.y + %ScoreLabel.size.y * randf_range(0.5, 0.9);
	
	%ScoreLabel.add_child(modifier_label);
	modifier_label.global_position = modifier_position

func _input(event: InputEvent) -> void:
	if EventManager.is_event_right_click(event):
		unselect_item()

func _on_client_served( _ingredients :Array[IngredientResource], modifiers :Array[float] ) -> void:
	var waffle_score = 0;
	
	
	current_score += waffle_score;
	pass

func _on_client_clicked( client :CharacterNode ) -> void:
	var selected_waffle = get_selected_waffle();
	if selected_waffle == null:
		if not client.has_order_visible():
			client.show_order();
		return;
	
	var client_order = client.get_ordered_waffle()
	var waffle_score = get_waffle_score(selected_waffle, client_order);
	
	change_score(waffle_score);
	unselect_item();
	selected_waffle.queue_free();
	
	client._leaving()

func get_waffle_score( selected_waffle :WaffleNode, client_ordered_waffle :WaffleNode ) -> int:
	var valid_ingredients_multipliers = 0;
	var missing_ingredients_multipliers = 0;
	var overloaded_ingredients_multiplier = 0;
	var unwanted_ingredients_multiplier = 0;
	
	
	if selected_waffle.get_waffle_ADN() == client_ordered_waffle.get_waffle_ADN():
		valid_ingredients_multipliers += 5.0; # bonus for perfect waffle
		for multiplier in selected_waffle.get_multipliers():
			valid_ingredients_multipliers += multiplier;
	else:
		var waffle_composition = selected_waffle.get_waffle_composition();
		var order_composition = client_ordered_waffle.get_waffle_composition();
		
		var checked_ingredients = []
		for waffle_ingredient in waffle_composition.keys():
			if not order_composition.has(waffle_ingredient):
				unwanted_ingredients_multiplier += waffle_composition[waffle_ingredient]
			elif waffle_composition[waffle_ingredient] == order_composition[waffle_ingredient]:
				valid_ingredients_multipliers += waffle_composition[waffle_ingredient]
			else:
				var delta = waffle_composition[waffle_ingredient] - order_composition[waffle_ingredient];
				if delta < 0:
					valid_ingredients_multipliers += waffle_composition[waffle_ingredient]
					missing_ingredients_multipliers += abs(delta);
				else:
					valid_ingredients_multipliers += order_composition[waffle_ingredient]
					overloaded_ingredients_multiplier += abs(delta);
			checked_ingredients.push_back(waffle_ingredient)
		
		for waffle_ingredient in order_composition.keys():
			if checked_ingredients.has(waffle_ingredient):
				continue
			missing_ingredients_multipliers += order_composition[waffle_ingredient];
	
	var total := 0;
	total += valid_ingredients_multipliers * score_by_valid_ingredient
	total += missing_ingredients_multipliers * score_by_missing_ingredient
	total += overloaded_ingredients_multiplier * score_by_overloaded_ingredient
	total += unwanted_ingredients_multiplier * score_by_unwanted_ingredient
	
	return total;

var sending_tween :Tween;
func _on_bell_clicked() -> void:
	var waffle_node = get_selected_waffle();
	if waffle_node == null:
		return;
	
	var free_waffle_slot :Control;
	for waffle_slot in reception_waffle_slots:
		if waffle_slot.get_child_count() == 0:
			free_waffle_slot = waffle_slot;
	
	if free_waffle_slot == null:
		return
	
	if sending_tween != null:
		sending_tween.kill();
	
	unselect_item();
	waffle_node.sent_to_reception = true;
	sending_tween = create_tween();
	var waffle_global_position = get_global_mouse_position();
	waffle_node.reparent(free_waffle_slot);
	waffle_node.global_position = waffle_global_position;
	sending_tween.parallel().tween_property(waffle_node, "scale", Vector2.ONE * reception_waffle_scale, waffle_sending_duration);
	sending_tween.parallel().tween_property(waffle_node, "position", Vector2.ZERO, waffle_sending_duration);

func get_selected_ingredient() -> IngredientResource:
	var current_selected_item = selected_item_control._selected_item
	if current_selected_item == null:
		return;
	
	current_selected_item = current_selected_item as IngredientStockpileNode
	if current_selected_item == null:
		return;
	
	return current_selected_item.ingredient;

func get_selected_waffle() -> WaffleNode:
	var current_selected_item = selected_item_control._selected_item
	if current_selected_item == null:
		return;
	
	current_selected_item = current_selected_item as WaffleNode
	if current_selected_item == null:
		return;
	
	return current_selected_item;

func unselect_item() -> void:
	var current_selected_item = selected_item_control._selected_item
	if current_selected_item == null:
		return
	
	if current_selected_item is IngredientStockpileNode:
		current_selected_item.visible = true;
	
	selected_item_control.unselect_item()

func _on_client_missed() -> void:
	change_score(score_by_missed_client)

func _on_stockpile_clicked( stockpile :IngredientStockpileNode ) -> void:
	if stockpile.ingredient.category == CookingManager.CATEGORIES.BOX:
		%AssemblyScreen.spawn_waffle_box();
		return
	
	if selected_item_control.has_item():
		unselect_item()
	
	stockpile.visible = false;
	selected_item_control.select_item(stockpile);

func _on_waffle_burnt() -> void:
	change_score(score_by_burned_waffle)

func _on_waffle_trashed( waffle_node :WaffleNode ) -> void:
	var total_cost := 0
	for ingredient in waffle_node.get_ingredients():
		total_cost += score_by_trashed_ingredient;
	change_score(total_cost)

func _on_trash_clicked() -> void:
	var selected_waffle := selected_item_control._selected_item as WaffleNode
	var selected_stockpile := selected_item_control._selected_item as IngredientStockpileNode
	if not selected_item_control.has_item():
		return
	
	unselect_item();
	if selected_stockpile != null:
		change_score(score_by_trashed_ingredient)
		if selected_stockpile.ingredient.category == CookingManager.CATEGORIES.WAFFLE :
			selected_stockpile.queue_free()
	
	if selected_waffle != null:
		selected_waffle.queue_free()
		_on_waffle_trashed(selected_waffle);

func _move_screen( screen_move :Vector2i ) -> void:
	camera_2d.position.x += screen_move.x * screen_size.x
	camera_2d.position.y += screen_move.y * screen_size.y
	EventManager.screen_moved.emit()


func _on_waffle_clicked(waffle_node: WaffleNode) -> void:
	var ingredient :IngredientResource
	var selected_stockpile := selected_item_control._selected_item as IngredientStockpileNode
	if selected_item_control.has_item():
		if selected_stockpile == null:
			return;
		
		unselect_item()
		var ingredient_added = waffle_node.add_ingredient(selected_stockpile.ingredient, selected_stockpile.multiplier);
		
		if ingredient_added && (selected_stockpile.ingredient.category == CookingManager.CATEGORIES.WAFFLE) :
			selected_stockpile.queue_free()
	else:
		selected_item_control.select_item(waffle_node);



func camera_up() -> void:
	_move_screen( Vector2i(0.0, -1.0) )
func camera_right() -> void:
	_move_screen( Vector2i(1.0, 0.0) )
func camera_down() -> void:
	_move_screen( Vector2i(0.0, 1.0) )
func camera_left() -> void:
	_move_screen( Vector2i(-1.0, 0.0) )
