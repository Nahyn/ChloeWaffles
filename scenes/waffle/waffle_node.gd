extends Node2D
class_name WaffleNode

const INGREDIENT_NODE = preload("uid://c88woq5hpjjb2")

@onready var ingredient_container: CanvasGroup = $IngredientSpriteContainer
@export var box_visible := true;
@export var ingredient_margin := -40.0:
	set(margin):
		ingredient_margin = margin;
		_update_y_positions.call_deferred()

@onready var container_inside: Sprite2D = %ContainerInside
@onready var container_outside: Sprite2D = %ContainerOutside

@export var locked := false;
var sent_to_reception := false;

func _ready() -> void:
	if not %ContainerInside == null:
		container_inside.visible = box_visible
		container_outside.visible = box_visible

func get_waffle_ADN() -> String:
	var adn := "";
	
	for ingredient in get_ingredients():
		adn += "_" + ingredient.name
	
	return adn;

func get_waffle_composition() -> Dictionary[IngredientResource, int]:
	var composition :Dictionary[IngredientResource, int] = {};
	
	for ingredient in get_ingredients():
		if not composition.has(ingredient):
			composition[ingredient] = 0
		composition[ingredient] += 1;
	
	return composition;

func make_passable() -> void:
	%Control.mouse_filter = Control.MOUSE_FILTER_IGNORE

func get_ingredients() -> Array[IngredientResource]:
	var ingredient_list :Array[IngredientResource] = []
	
	for layer in ingredient_container.get_children():
		layer = layer as IngredientNode;
		if layer == null:
			continue
		ingredient_list.push_back(layer.ingredient);
	
	return ingredient_list;

func get_multipliers() -> Array[float]:
	var ingredient_list :Array[float] = []
	
	for layer in ingredient_container.get_children():
		layer = layer as IngredientNode;
		if layer == null:
			continue
		ingredient_list.push_back(layer.multiplier);
	
	return ingredient_list;

func is_empty_box() -> bool:
	return (ingredient_container.get_child_count() == 2);

func create_from_ingredients( ingredient_list :Array[IngredientResource]) -> void:
	if ingredient_container == null:
		create_from_ingredients.call_deferred(ingredient_list);
		return
	
	for layer in ingredient_container.get_children():
		layer = layer as IngredientNode;
		if layer == null:
			continue
		layer.queue_free()
	
	for index in ingredient_list.size():
		add_ingredient(ingredient_list[index], 1.0);

func add_ingredient( ingredient :IngredientResource, multiplier :float ) -> bool:
	# ONLY waffles can be added if the box is empty
	if is_empty_box() and ingredient.category != CookingManager.CATEGORIES.WAFFLE:
		return false;
	
	# Waffle can ONLY be added if there is nothing in the box
	if ingredient.category == CookingManager.CATEGORIES.WAFFLE and not is_empty_box():
		return false;
	
	var ingredient_node := INGREDIENT_NODE.instantiate() as IngredientNode
	ingredient_node.ingredient = ingredient;
	ingredient_node.multiplier = multiplier;
	add_ingredient_node(ingredient_node);
	
	return true;

func add_ingredient_node(ingredient_node :IngredientNode) -> void:
	ingredient_container.add_child(ingredient_node);
	container_outside.move_to_front()
	_update_y_positions.call_deferred()

func _update_y_positions() -> void:
	for layer in ingredient_container.get_children():
		layer = layer as IngredientNode;
		if layer == null:
			continue
		layer.position.y = (layer.get_index()-1) * ingredient_margin;

func _on_control_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event) and not locked:
		EventManager.waffle_clicked.emit(self)
