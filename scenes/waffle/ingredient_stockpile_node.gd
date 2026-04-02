@tool
extends TextureRect
class_name IngredientStockpileNode

signal clicked( ingredient_stockpile :IngredientStockpileNode )

var forced_texture :Texture2D

@export var multiplier := 1.0;
@export var ingredient :IngredientResource:
	set(_ingredient):
		ingredient = _ingredient
		_update_texture()

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;
	gui_input.connect(_on_gui_input)
	
	_update_texture.call_deferred()

func _update_texture():
	if forced_texture != null:
		texture = forced_texture;
		return
	
	if ingredient == null:
		texture = null;
		return;
	
	if not (ingredient.stockpile_texture == null):
		texture = ingredient.stockpile_texture
		return
	
	if not (ingredient.selected_texture == null):
		texture = ingredient.selected_texture
		return
	
	texture = ingredient.sprite_texture

func is_batter() -> bool:
	var tmp_ingredient = ingredient as WaffleIngredientResource
	if tmp_ingredient != null and texture == tmp_ingredient.batter_texture:
		return true
	
	return false;

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and not is_batter():
		EventManager.stockpile_clicked.emit(self)
		clicked.emit(self)
