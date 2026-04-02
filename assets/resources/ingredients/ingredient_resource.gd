extends Resource
class_name IngredientResource

@export var category :CookingManager.CATEGORIES = 0;
@export var name := "[DEFAULT INGREDIENT NAME]";

@export var sprite_texture :Texture2D;
@export var selected_texture :Texture2D;
@export var stockpile_texture :Texture2D;

func get_selected_texture() -> Texture2D:
	if selected_texture != null:
		return selected_texture
	
	return get_stockpile_texture()

func get_stockpile_texture() -> Texture2D:
	if stockpile_texture != null:
		return stockpile_texture
	
	return sprite_texture
