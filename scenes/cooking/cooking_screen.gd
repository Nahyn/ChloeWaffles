extends Control
class_name CookingScreen

@onready var waffle_positionner: Control = $WafflePositionner
const WAFFLE_NODE = preload("uid://c4ktetgyfxye6")

func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	for stockpile in %StockpileContainer.get_children():
		(stockpile as IngredientStockpileNode).clicked.connect(_on_stockpile_clicked)

func _on_stockpile_clicked( stockpile :IngredientStockpileNode ) -> void:
	prints("_on_stockpile_clicked", stockpile);
	var ingredient = stockpile.ingredient
	
	var waffle_node :WaffleNode
	if waffle_positionner.get_child_count() == 0:
		if not ingredient.category == IngredientResource.CATEGORY.BASE:
			return
		waffle_node = WAFFLE_NODE.instantiate() as WaffleNode
		waffle_node.ingredients.push_back(ingredient);
		waffle_positionner.add_child(waffle_node);
	else:
		waffle_node = waffle_positionner.get_child(0);
		waffle_node.add_ingredient(ingredient);
	
