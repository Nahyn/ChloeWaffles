extends Node2D
class_name WafflePlateNode

signal plate_clicked();

@export var waffle_margin_base := -50.0
@export var waffle_margin_expended := -100.0
var current_margin := waffle_margin_base


func add_waffle( waffle_stockpile :IngredientStockpileNode ) -> void:
	waffle_stockpile.global_position = %StockpileContainer.global_position
	if waffle_stockpile.get_parent() == null:
		%StockpileContainer.add_child(waffle_stockpile);
	else:
		waffle_stockpile.reparent(%StockpileContainer);
	waffle_stockpile.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM);
	

func _update_waffle_positions() -> void:
	for waffle_stockpile in %StockpileContainer.get_children():
		waffle_stockpile.position.y = waffle_stockpile.get_index() * current_margin



func _on_plate_mouse_entered() -> void:
	current_margin = waffle_margin_expended
	_update_waffle_positions.call_deferred()

func _on_plate_mouse_exited() -> void:
	current_margin = waffle_margin_base
	_update_waffle_positions.call_deferred()

func _on_stockpile_container_child_order_changed() -> void:
	_update_waffle_positions.call_deferred()


func _on_plate_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		plate_clicked.emit()
