extends Node2D
class_name GameScreen

@onready var camera_2d: Camera2D = $Camera2D
var screen_size := Vector2(1920, 1080);

const SCORE_LABEL = preload("uid://dcu1mgvn7ko8r")

@export var score_by_ingredient := 20
@export var client_missed_penalty := 100
@export var waffle_burnt_penalty := 30

var current_time
var current_score := 0;

var score_objective := 0
var time_lime := 20

var current_selected_item

func _ready() -> void:
	EventManager.client_served.connect(_on_client_served)
	EventManager.client_missed.connect(_on_client_missed)
	EventManager.waffle_trashed.connect(_on_waffle_trashed)
	EventManager.waffle_burnt.connect(_on_waffle_burnt)

func _on_client_served( ingredients :Array[IngredientResource], modifiers :Array[float] ) -> void:
	var waffle_score = 0;
	
	for modifier in modifiers:
		waffle_score += score_by_ingredient * modifier
	
	current_score += waffle_score;
	pass

func change_score( _modifier :int ) -> void:
	current_score += _modifier
	%ScoreLabel.text = str(current_score);
	
	var modifier_label := SCORE_LABEL.instantiate() as ScoreLabel;
	var modifier_str = str(_modifier);
	if _modifier > 0:
		modifier_str = str("+", modifier_str);
	modifier_label.text = modifier_str
	
	var score_position = %ScoreLabel.global_position
	var limit_position = score_position + %ScoreLabel.size
	
	var modifier_position = Vector2.ZERO;
	modifier_position.x = lerp(score_position.x, limit_position.y, randf_range(0.1, 0.9))
	modifier_position.y = lerp(score_position.y, limit_position.y, randf_range(0.1, 0.9))
	
	add_child(modifier_label);
	modifier_label.global_position = modifier_position

func _on_client_missed() -> void:
	change_score(-client_missed_penalty)

func _on_waffle_burnt() -> void:
	change_score(-waffle_burnt_penalty)

func _on_waffle_trashed( waffle_node :WaffleNode ) -> void:
	var total_cost := 0
	for ingredient in waffle_node.ingredients:
		total_cost += score_by_ingredient;
	change_score(-total_cost)

func _move_screen( screen_move :Vector2i ) -> void:
	camera_2d.position.x += screen_move.x * screen_size.x
	camera_2d.position.y += screen_move.y * screen_size.y
	EventManager.screen_moved.emit()

func camera_up() -> void:
	_move_screen( Vector2i(0.0, -1.0) )
func camera_right() -> void:
	_move_screen( Vector2i(1.0, 0.0) )
func camera_down() -> void:
	_move_screen( Vector2i(0.0, 1.0) )
func camera_left() -> void:
	_move_screen( Vector2i(-1.0, 0.0) )
