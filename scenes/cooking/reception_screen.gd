extends Control
class_name ReceptionScreen

signal go_screen_down()
signal client_clicked( client :CharacterNode )

const CHARACTER_NODE = preload("uid://wcecrj3i8y8j")
@export var max_client := 3
@export var client_movement_duration := Vector2(1.0, 2.0);
@export var daily_client_count = 5;

var CLIENTS :Array[CharacterResource] = [
	load("uid://bqsq8s3yro622"),
	load("uid://v4eaqn28ydoa"),
]

var client_movement_tween :Tween
var daily_clients :Array[CharacterResource] = [
	load("uid://bqsq8s3yro622"),
	load("uid://v4eaqn28ydoa"),
	load("uid://bqsq8s3yro622"),
	load("uid://v4eaqn28ydoa"),
	load("uid://bqsq8s3yro622"),
	load("uid://v4eaqn28ydoa"),
	load("uid://bqsq8s3yro622"),
];

func _ready() -> void:
	generate_daily_clients.call_deferred()

func generate_daily_clients() -> void:
	var possible_clients :Array[CharacterResource] = CLIENTS.duplicate();
	
	for index in daily_client_count:
		var valid_client :CharacterResource
		
		while (valid_client == null) and (not possible_clients.is_empty()):
			var test_client = possible_clients.pick_random()
			possible_clients.erase(test_client);
			if not daily_clients.has(test_client):
				valid_client = test_client
		
		if valid_client == null:
			break;
		daily_clients.push_back(valid_client);

func spawn_next_client() -> void:
	if daily_clients.is_empty():
		return
	
	var tmp_character_positionner := PathFollow2D.new()
	tmp_character_positionner.rotates = false;
	var tmp_character_node :CharacterNode = CHARACTER_NODE.instantiate() as CharacterNode
	
	tmp_character_node.character_resource = daily_clients.pop_front()
	tmp_character_node.tree_exited.connect(tmp_character_positionner.queue_free);
	tmp_character_node.clicked.connect( client_clicked.emit )
	tmp_character_positionner.tree_exited.connect(_update_client_positions);
	tmp_character_positionner.add_child(tmp_character_node)
	%ClientWaitingLine.add_child(tmp_character_positionner);
	tmp_character_positionner.progress_ratio = 0.0;
	
	_update_client_positions()


func _update_client_positions() -> void:
	if not client_movement_tween == null:
		client_movement_tween.kill()
	
	var client_positionners = %ClientWaitingLine.get_children()
	client_movement_tween = create_tween();
	for index in client_positionners.size():
		var client_positionner = client_positionners[index] as PathFollow2D;
		client_movement_tween.parallel().tween_property(client_positionner, "progress_ratio", 1.0 - index/float(max_client), randf_range(client_movement_duration.x, client_movement_duration.y))

func _on_go_down_button_pressed() -> void:
	go_screen_down.emit();

func _on_button_pressed() -> void:
	spawn_next_client()
