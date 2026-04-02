extends Control
class_name WaffleMakerScreen

signal go_screen_left()

@export var waffle_plate :WafflePlateNode

func _on_go_left_button_pressed() -> void:
	go_screen_left.emit()

func _on_waffle_finished(ingredient_resource: WaffleIngredientResource, multiplier: float) -> void:
	var new_waffle_stockpile := IngredientStockpileNode.new();
	new_waffle_stockpile.ingredient = ingredient_resource
	new_waffle_stockpile.multiplier = multiplier
	waffle_plate.add_waffle(new_waffle_stockpile)
