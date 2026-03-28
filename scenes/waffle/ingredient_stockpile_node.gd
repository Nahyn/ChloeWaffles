extends Node2D
class_name IngredientStockpileNode

signal clicked( ingredient_stockpile :IngredientStockpileNode )

@export var texture :Texture2D
@export var collision_shape :CollisionShape2D


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("_on_area_2d_input_event", name);
		clicked.emit(self)
