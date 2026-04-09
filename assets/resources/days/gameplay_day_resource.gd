extends Resource
class_name GameplayDayResouce

@export var day_score := 0
@export var daily_client_count := 5
@export var daily_clients :Array[CharacterResource] = []
@export var client_delay := Vector2(4.0, 10.0);
@export var client_movement_duration := Vector2(1.0, 1.0);
