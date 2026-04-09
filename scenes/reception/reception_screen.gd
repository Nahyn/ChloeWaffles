extends Control
class_name ReceptionScreen

signal go_screen_down()

var chloe_texture_paths :Array[String] = [
	"res://assets/graphics/sprites/Chloe_clientSmile.png",
	"res://assets/graphics/sprites/Chloe_clientTalking.png",
	"res://assets/graphics/sprites/Chloe_playerNeutral.png",
	"res://assets/graphics/sprites/Chloe_playerSmile.png",
	"res://assets/graphics/sprites/Chloe_playerTalking.png",
	"res://assets/graphics/sprites/Chloe_yawn.png",
];

@onready var client_spawn_timer: Timer = $ClientSpawnTimer
@export var client_delay := Vector2(4.0, 10.0);

const CHARACTER_NODE = preload("uid://wcecrj3i8y8j");
@export var max_client := 3
@export var client_movement_duration := Vector2(1.0, 2.0);
@export var daily_client_count = 5;

var CLIENTS_PATHS :Array[CharacterResource] = [
	load("res://assets/resources/characters/alis_character.tres"),
	load("res://assets/resources/characters/alpha_character.tres"),
	load("res://assets/resources/characters/dodo_character.tres"),
	load("res://assets/resources/characters/juniper_character.tres"),
	load("res://assets/resources/characters/mino_character.tres"),
	load("res://assets/resources/characters/nael_character.tres"),
	load("res://assets/resources/characters/ruben_character.tres"),
]

var client_movement_tween :Tween
var daily_clients :Array[CharacterResource] = [];
var visible_clients :Array[CharacterNode] = [];

func start() -> void:
	generate_daily_clients.call_deferred()
	set_timer_until_next_client.call_deferred()

func randomise_chloe() -> void:
	%ChloeTextureRect.texture = load(chloe_texture_paths.pick_random())

func generate_daily_clients() -> void:
	var possible_clients :Array[CharacterResource] = CLIENTS_PATHS.duplicate();
	while (daily_client_count > daily_clients.size()) and (not possible_clients.is_empty()):
		var test_client_path = possible_clients.pick_random()
		daily_clients.push_back(test_client_path);
		possible_clients.erase(test_client_path);

func spawn_next_client() -> void:
	if daily_clients.is_empty() or %ClientWaitingLine.get_child_count() >= max_client:
		return
	
	var tmp_character_positionner := PathFollow2D.new()
	tmp_character_positionner.rotates = false;
	tmp_character_positionner.y_sort_enabled = true;
	var tmp_character_node :CharacterNode = CHARACTER_NODE.instantiate() as CharacterNode
	visible_clients.push_back(tmp_character_node);
	
	tmp_character_node.character_resource = daily_clients.pop_front()
	tmp_character_node.tree_exited.connect(tmp_character_positionner.queue_free);
	tmp_character_node.tree_exited.connect(_on_client_leaving.bind(tmp_character_node));
	tmp_character_positionner.tree_exited.connect(_update_client_positions);
	tmp_character_positionner.add_child(tmp_character_node)
	%ClientWaitingLine.add_child(tmp_character_positionner);
	tmp_character_positionner.progress_ratio = 1.0;
	
	_update_client_positions()

func _on_client_leaving( client_node :CharacterNode ) -> void:
	visible_clients.erase(client_node);
	
	if visible_clients.size() == 0 and daily_clients.size() == 0:
		EventManager.last_client_leaving.emit()

func _update_client_positions() -> void:
	if not client_movement_tween == null:
		client_movement_tween.kill()
	
	var client_positionners = %ClientWaitingLine.get_children()
	client_movement_tween = create_tween();
	for index in client_positionners.size():
		var client_positionner = client_positionners[index] as PathFollow2D;
		client_movement_tween.parallel().tween_property(client_positionner, "progress_ratio", index/float(max_client), randf_range(client_movement_duration.x, client_movement_duration.y))

func _on_go_down_button_pressed() -> void:
	go_screen_down.emit();

func set_timer_until_next_client() -> void:
	if client_spawn_timer == null:
		return;
	client_spawn_timer.start( randf_range( client_delay.x, client_delay.y ) );

func _on_client_spawn_timer_timeout() -> void:
	spawn_next_client()
	if not daily_clients.is_empty():
		set_timer_until_next_client();
