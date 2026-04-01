extends Node2D
class_name WaffleNode

signal clicked( waffle_node :WaffleNode )

@onready var ingredient_sprite_container: CanvasGroup = $IngredientSpriteContainer
@export var ingredient_margin := -40.0;
@export var ingredients :Array[IngredientResource] = []
@export var quality_multiplers :Array[float] = []

@onready var container_inside: Sprite2D = %ContainerInside
@onready var container_outside: Sprite2D = %ContainerOutside

var sent_to_reception := false;

func _init(new_ingredients :Array[IngredientResource] = []) -> void:
	if new_ingredients.size() > 0:
		create_from_ingredients.call_deferred(new_ingredients);

func _ready() -> void:
	if ingredients != null:
		create_from_ingredients.call_deferred(ingredients.duplicate());

func get_waffle_ADN() -> String:
	var adn := "";
	
	for ingredient in ingredients:
		adn += "_" + ingredient.name
	
	return adn;

func get_waffle_composition() -> Dictionary[IngredientResource, int]:
	var composition :Dictionary[IngredientResource, int] = {};
	
	for ingredient in ingredients:
		if not composition.has(ingredient):
			composition[ingredient] = 0
		composition[ingredient] += 1;
	
	return composition;

func create_from_ingredients( new_ingredients :Array[IngredientResource] ) -> void:
	if ingredient_sprite_container == null:
		return
	
	ingredients.clear();
	
	for ingredient_resource in new_ingredients:
		add_ingredient(ingredient_resource);
	
	_update_sprites()

func add_ingredient( ingredient :IngredientResource, refresh_display :bool = true ) -> bool:
	var last_ingredient_category :CookingManager.CATEGORIES
	if ingredients.size() == 0 and ingredient.category != CookingManager.CATEGORIES.WAFFLE:
		return false;
	
	if ingredients.size() > 0:
		last_ingredient_category = ingredients[ingredients.size() -1].category
		if last_ingredient_category == ingredient.category:
			return false;
	ingredients.push_back(ingredient);
	
	if refresh_display:
		_update_sprites.call_deferred();
	return true;

func _update_sprites() -> void:
	if ingredient_sprite_container == null:
		return
	
	for ingredient_sprite in ingredient_sprite_container.get_children():
		if [container_inside, container_outside].has(ingredient_sprite):
			continue;
		ingredient_sprite.queue_free();
	
	for ingredient_index in ingredients.size():
		var ingredient_resource :IngredientResource = ingredients[ingredient_index]
		var tmp_ingredient_sprite := Sprite2D.new();
		tmp_ingredient_sprite.texture = ingredient_resource.sprite_texture;
		ingredient_sprite_container.add_child(tmp_ingredient_sprite);
		tmp_ingredient_sprite.position.y = ingredient_index * ingredient_margin;

func _on_control_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		clicked.emit(self);
