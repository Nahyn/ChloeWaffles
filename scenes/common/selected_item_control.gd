extends Control
class_name SelectedItemControl

@onready var texture_rect: TextureRect = $TexturePositionner/TextureRect

var _selected_item
var target_position := Vector2.ZERO :
	set(new_position):
		target_position = new_position
		_update_position.call_deferred();

func _ready() -> void:
	%TextureRect.visible = false;

func select_item( item :Node ) -> void:
	if has_item():
		return
	_selected_item = item
	
	_update_graphics()

func unselect_item() -> void:
	_reset_graphics();
	_selected_item = null


func has_item() -> bool:
	return not (_selected_item == null)

func _process(_delta: float) -> void:
	var new_mouse_pos = get_global_mouse_position();
	if not _selected_item == null:
		global_position = new_mouse_pos;
		return
	
	if (new_mouse_pos - target_position).length_squared() > 5.0:
		target_position = get_global_mouse_position()

func _reset_graphics() -> void:
	%TextureRect.visible = false;
	for item in %TexturePositionner.get_children():
		if item != %TextureRect:
			item.queue_free()
	if _selected_item != null:
		_selected_item.visible = true;

func _update_graphics() -> void:
	_reset_graphics()
	
	if _selected_item is IngredientStockpileNode:
		%TextureRect.visible = true;
		%TextureRect.texture = _selected_item.ingredient.get_selected_texture();
		
		if _selected_item.ingredient is WaffleIngredientResource:
			_selected_item.visible = false;
		
		return
	
	if _selected_item is WaffleNode:
		var item_double = _selected_item.duplicate()
		_selected_item.visible = false;
		%TexturePositionner.add_child(item_double);
		item_double.position = Vector2.ZERO;
		item_double.visible = true;
		item_double.make_passable()

var movement_tween :Tween
func _update_position() -> void:
	
	if movement_tween != null:
		movement_tween.kill()
	
	var delta_x = (target_position - global_position).x;
	
	var target_rotation = -PI/10.0;
	if delta_x > 0:
		target_rotation *= -1;
	movement_tween = create_tween();
	movement_tween.parallel().tween_property(self, "global_position", target_position, 0.2);
	movement_tween.parallel().tween_property($TexturePositionner, "rotation", target_rotation, 0.1);
	movement_tween.tween_property($TexturePositionner, "rotation", 0.0, 0.1);
