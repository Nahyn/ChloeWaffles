extends Sprite2D
class_name IngredientNode

var ingredient :IngredientResource
var multiplier := 1.0

func _ready() -> void:
	_update_texture.call_deferred()

func _update_texture() -> void:
	if ingredient == null:
		return
	texture = ingredient.sprite_texture
