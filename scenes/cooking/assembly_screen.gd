extends Control
class_name AssemblyScreen

signal go_screen_up()
signal go_screen_right()

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
	if %WafflePositionner.get_child_count() == 0:
		if not ingredient.category == IngredientResource.CATEGORY.WAFFLE:
			return
		waffle_node = WAFFLE_NODE.instantiate() as WaffleNode
		waffle_node.ingredients.push_back(ingredient);
		%WafflePositionner.add_child(waffle_node);
	else:
		waffle_node = %WafflePositionner.get_child(0);
		waffle_node.add_ingredient(ingredient);
	


func _on_go_right_button_pressed() -> void:
	go_screen_right.emit()

func _on_go_up_button_pressed() -> void:
	go_screen_up.emit()
