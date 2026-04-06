extends Control
class_name MainMenuScreen

var chloe_texture_paths :Array[String] = [
	"res://assets/graphics/sprites/Chloe_clientSmile.png",
	"res://assets/graphics/sprites/Chloe_clientTalking.png",
	"res://assets/graphics/sprites/Chloe_playerNeutral.png",
	"res://assets/graphics/sprites/Chloe_playerSmile.png",
	"res://assets/graphics/sprites/Chloe_playerTalking.png",
	"res://assets/graphics/sprites/Chloe_yawn.png",
];
var current_texture_path :String

func _ready() -> void:
	randomize_texture.call_deferred()

func randomize_texture() -> void:
	var possible_paths = chloe_texture_paths.duplicate()
	possible_paths.erase(current_texture_path);
	current_texture_path = possible_paths.pick_random()
	%ChloeTextureRect.texture = load(current_texture_path)


func _on_chloe_texture_rect_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_click(event):
		randomize_texture()

func _on_story_button_pressed() -> void:
	GameplayController.start_story();

func _on_freegame_button_pressed() -> void:
	GameplayController.start_freegame();

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.
