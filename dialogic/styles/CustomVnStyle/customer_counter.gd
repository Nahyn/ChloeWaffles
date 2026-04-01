@tool
extends DialogicLayoutLayer

const CHLOE_DIALOGIC_CHARACTER :DialogicCharacter = preload("uid://dfjn53vas77fa")

func _ready() -> void:
	Dialogic.Portraits.character_joined.connect(_on_character_joined)

func _on_character_joined( _info :Dictionary ) -> void:
	if _info["character"] == CHLOE_DIALOGIC_CHARACTER:
		var node = _info["node"] as Node2D;
		node.z_index = 100;
