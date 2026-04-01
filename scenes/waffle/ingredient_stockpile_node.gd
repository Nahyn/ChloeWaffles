@tool
extends TextureRect
class_name IngredientStockpileNode

signal clicked( ingredient_stockpile :IngredientStockpileNode )

@export var ingredient :IngredientResource:
	set(_ingredient):
		ingredient = _ingredient
		_update_texture()

func _ready() -> void:
	_update_texture.call_deferred()

func _update_texture():
	texture = ingredient.sprite_texture
	if not (ingredient.stockpile_texture == null):
		texture = ingredient.stockpile_texture

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		clicked.emit(self)
