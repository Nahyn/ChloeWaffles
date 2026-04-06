extends Node

enum CATEGORIES { BOX, WAFFLE, FRUIT, TOPPING, DECORATION }

var _ingredients_dumplist :Array[IngredientResource] = [
	load("uid://b5jwhytiglsm7"),
	load("uid://mbeqc8t5a68o"),
	load("uid://dqb0ffljt0gk8"),
	load("uid://d3o40elolsvwp"),
	load("uid://dt2d3lirdtt8d"),
	load("uid://dapcf14x3l8uw"),
	load("uid://dpuxd80flr3ho"),
	load("uid://b62e540gt4f8c"),
	load("uid://buj2sh0tj8hxx"),
	load("uid://cwdvvh2xikw66"),
	load("uid://bwk23l5wwlfm1"),
	load("uid://cc5idw53n876u"),
	load("uid://cds2w3m16vfnn"),
	load("uid://cvwktnd6y1tbb"),
	load("uid://cgc0tyd6cason"),
	load("uid://f6porltb1r4f"),
	load("uid://67delmfvixbv"),
	load("uid://cc8hfrij5srvg"),
	load("uid://do3h8hal75hjg"),
	load("uid://dl6u3q2t2e82l"),
	load("uid://d3xi0174b2hs1"),
	load("uid://dtrukfpdja7cn"),
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
