extends Resource
class_name CharacterResource

@export var name := "DEFAULT_CHARACTER_NAME";
@export var sprite :Texture2D;

@export var though_bubble_y := -950

@export var usual_order_ingredients :Array[IngredientResource] = []
@export var usual_order_categories :Array[CookingManager.CATEGORIES] = []

func get_random_order() -> Array[IngredientResource]:
	var random_order :Array[IngredientResource] = []
	
	for ingredient_index in usual_order_ingredients.size():
		var tmp_ingredient := usual_order_ingredients[ingredient_index];
		
		if tmp_ingredient == null:
			var category = usual_order_categories[ingredient_index];
			if category == null:
				continue
			tmp_ingredient = CookingManager.get_random_ingredient_from_category(category);
		
		random_order.push_back(tmp_ingredient);
	
	return random_order;
