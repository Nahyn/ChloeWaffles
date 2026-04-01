extends Control
class_name DialogScene

@export var dialogic_timeline :DialogicTimeline;
const CHLOE_DIALOGIC_CHARACTER :DialogicCharacter = preload("uid://dfjn53vas77fa")

func _ready() -> void:
	Dialogic.Text.about_to_show_text.connect(_on_about_to_show_text)
	Dialogic.Portraits.character_joined.connect(_on_character_joined)
	Dialogic.Portraits.character_portrait_changed.connect(_on_character_portrait_changed)
	start_timeline.call_deferred();

func start_timeline() -> void:
	Dialogic.start(dialogic_timeline);

func _on_about_to_show_text( _info :Dictionary ) -> void:
	var character_talking = _info["character"];
	prints("_on_about_to_show_text")
	prints("_info", _info)
	prints("character_talking", character_talking)

func _on_character_portrait_changed( _info :Dictionary ) -> void:
	prints("_on_character_portrait_changed")
	prints("_info", _info)

func _on_character_joined( _info :Dictionary ) -> void:
	prints("_on_character_joined")
	if _info["character"] == CHLOE_DIALOGIC_CHARACTER:
		var node = _info["node"] as Node2D;
		node.z_index = 100;
