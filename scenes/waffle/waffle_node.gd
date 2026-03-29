extends Node2D
class_name WaffleNode

@onready var ingredient_sprite_container: CanvasGroup = $IngredientSpriteContainer
@export var ingredients :Array[IngredientResource] = []
@export var ingredient_margin := -40.0;

func _init(new_ingredients :Array[IngredientResource] = []) -> void:
	prints("_init - ingredients", ingredients)
	if new_ingredients.size() > 0:
		create_from_ingredients.call_deferred(new_ingredients);

func _ready() -> void:
	prints("_ready - ingredients", ingredients)
	prints("_ready - ingredient_sprite_container", ingredient_sprite_container)
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
	
	for child in ingredient_sprite_container.get_children():
		child.queue_free()
	ingredients.clear();
	
	for ingredient_resource in new_ingredients:
		add_ingredient(ingredient_resource);

func add_ingredient( ingredient :IngredientResource ) -> bool:
	var last_ingredient_category :IngredientResource.CATEGORY
	if ingredients.size() == 0 and ingredient.category != IngredientResource.CATEGORY.BOX:
		return false;
	
	if ingredients.size() > 0:
		last_ingredient_category = ingredients[ingredients.size() -1].category
		if last_ingredient_category == ingredient.category:
			return false;
	ingredients.push_back(ingredient);
	
	if ingredient_sprite_container == null:
		return true
	
	var tmp_ingredient_sprite := Sprite2D.new();
	tmp_ingredient_sprite.texture = ingredient.sprite_texture;
	ingredient_sprite_container.add_child(tmp_ingredient_sprite);
	tmp_ingredient_sprite.position.y = tmp_ingredient_sprite.get_index() * ingredient_margin;
	return true;
