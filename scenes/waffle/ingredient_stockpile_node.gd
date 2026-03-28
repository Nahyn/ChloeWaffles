extends Control
class_name IngredientStockpileNode

signal clicked( ingredient_stockpile :IngredientStockpileNode )

@export var ingredient :IngredientResource

func _ready() -> void:
	_update_texture.call_deferred()

func _update_texture():
	if %TextureRect == null:
		return
	
	%TextureRect.texture = ingredient.sprite_texture
	if not (ingredient.stockpile_texture == null):
		%TextureRect.texture = ingredient.stockpile_texture

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	print("_on_area_2d_input_event", name);
	if event is InputEventMouseButton and event.is_pressed():
		clicked.emit(self)


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		clicked.emit(self)
