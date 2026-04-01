extends Node

enum CATEGORIES { BOX, WAFFLE, FRUIT, TOPPING, DECORATION }

var _ingredients_dumplist :Array[IngredientResource] = [
	load("uid://b5jwhytiglsm7"),
	load("uid://buj2sh0tj8hxx"),
	load("uid://df1k3gluind2a"),
	load("uid://do3h8hal75hjg"),
	load("uid://mbeqc8t5a68o")
]

var ingredients : Dictionary = {};

func get_category_name( ingredient_category :CATEGORIES ) -> String:
	return CATEGORIES.keys()[ingredient_category];

func _init() -> void:
	_initialize_lists()

func _initialize_lists() -> void:
	ingredients.clear();
	
	for ingredient in _ingredients_dumplist:
		if not ingredients.has(ingredient.category):
			ingredients[ingredient.category] = []
		ingredients[ingredient.category].push_back(ingredient);

func get_random_ingredient_from_category( category :CATEGORIES ) -> IngredientResource:
	var ingredient :IngredientResource;
	
	if not ingredients.has(category):
		return ingredient
	
	ingredient = (ingredients[category] as Array[IngredientResource]).pick_random()
	return ingredient;
