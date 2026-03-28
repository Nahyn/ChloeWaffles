extends Resource
class_name IngredientResource

enum CATEGORY { BASE, FRUIT, TOPPING, DECORATION }

@export var category :CATEGORY = CATEGORY.BASE;
@export var name := "[DEFAULT INGREDIENT NAME]";

@export var sprite_texture :Texture2D;
@export var icon_texture :Texture2D;
