extends Control
class_name AssemblyScreen

signal waffle_sent( waffle_node :WaffleNode )

signal go_screen_up()
signal go_screen_right()

@export var reception_waffle_scale := 0.5;
@export var waffle_sending_duration := 0.5;
@export var waffle_slots :Array[Control] = []

const WAFFLE_NODE = preload("uid://c4ktetgyfxye6")

func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	for stockpile in %StockpileContainer.get_children():
		if not (stockpile as IngredientStockpileNode).clicked.is_connected(_on_stockpile_clicked):
			(stockpile as IngredientStockpileNode).clicked.connect(_on_stockpile_clicked)

func _on_stockpile_clicked( stockpile :IngredientStockpileNode ) -> void:
	prints("_on_stockpile_clicked", stockpile);
	var ingredient = stockpile.ingredient
	
	var waffle_node :WaffleNode
	prints("%WafflePositionner", %WafflePositionner.get_child_count());
	if %WafflePositionner.get_child_count() == 0:
		if not ingredient.category == CookingManager.CATEGORIES.BOX:
			return
		waffle_node = WAFFLE_NODE.instantiate() as WaffleNode
		%WafflePositionner.add_child(waffle_node);
		prints("waffle_node", waffle_node);
		prints("waffle_node.ingredients", waffle_node.ingredients);
	else:
		waffle_node = %WafflePositionner.get_child(0);
		var ingredient_added = waffle_node.add_ingredient(ingredient);
		prints("ingredient_added", ingredient_added);

var sending_tween :Tween;
func send_waffle() -> void:
	prints("send_waffle")
	var waffle_node :WaffleNode = %WafflePositionner.get_child(0) as WaffleNode;
	if waffle_node == null:
		return;
	
	var free_waffle_slot :Control;
	for waffle_slot in waffle_slots:
		prints("waffle_slot.get_child_count()", waffle_slot.get_child_count());
		if waffle_slot.get_child_count() == 0:
			free_waffle_slot = waffle_slot;
	
	if free_waffle_slot == null:
		return
	
	if sending_tween != null:
		sending_tween.kill();
	
	waffle_node.sent_to_reception = true;
	sending_tween = create_tween();
	var waffle_global_position = waffle_node.global_position;
	waffle_node.reparent(free_waffle_slot);
	waffle_node.global_position = waffle_global_position;
	sending_tween.parallel().tween_property(waffle_node, "scale", Vector2.ONE * reception_waffle_scale, waffle_sending_duration);
	sending_tween.parallel().tween_property(waffle_node, "position", Vector2.ZERO, waffle_sending_duration);
	
	waffle_sent.emit(waffle_node);
	


func _on_go_right_button_pressed() -> void:
	go_screen_right.emit()

func _on_go_up_button_pressed() -> void:
	go_screen_up.emit()


func _on_bell_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		send_waffle();
