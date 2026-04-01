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

func select_item( item, texture :Texture2D ) -> void:
	if is_occupied():
		return
	_selected_item = item
	%TextureRect.visible = true
	%TextureRect.texture = texture

func unselect_item() -> void:
	_selected_item = null
	%TextureRect.visible = false

func is_occupied() -> bool:
	return (_selected_item == null)

func _process(_delta: float) -> void:
	var new_mouse_pos = get_global_mouse_position();
	if not %TextureRect.visible:
		global_position = new_mouse_pos;
		return
	
	if (new_mouse_pos - target_position).length_squared() > 5.0:
		target_position = get_global_mouse_position()

var movement_tween :Tween
func _update_position() -> void:
	
	if movement_tween != null:
		movement_tween.kill()
	
	$TexturePositionner.rotation = -PI/20.0;
	movement_tween = create_tween();
	movement_tween.parallel().tween_property(self, "global_position", target_position, 0.1);
	movement_tween.parallel().tween_property($TexturePositionner, "rotation", 0.0, 0.2);
