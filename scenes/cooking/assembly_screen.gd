extends Control
class_name AssemblyScreen

signal waffle_clicked( waffle_node :WaffleNode );
signal waffle_sent( waffle_node :WaffleNode )

signal go_screen_up()
signal go_screen_right()

const WAFFLE_NODE = preload("uid://c4ktetgyfxye6")

func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	pass

func has_waffle() -> bool:
	return %WafflePositionner.get_child_count() > 0;

func spawn_waffle_box() -> void:
	if has_waffle():
		return;
	var waffle_node = WAFFLE_NODE.instantiate() as WaffleNode
	%WafflePositionner.add_child(waffle_node);

func _on_go_right_button_pressed() -> void:
	go_screen_right.emit()

func _on_go_up_button_pressed() -> void:
	go_screen_up.emit()

func _on_bell_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		EventManager.bell_clicked.emit();

func _on_trashcan_container_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		prints("trashcan clicked")
		EventManager.trash_clicked.emit()
