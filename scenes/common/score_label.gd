extends Control
class_name ScoreLabel

var text := "":
	set( _text ):
		text = _text
		if $ScoreLabel != null:
			$ScoreLabel.text = text;

func set_outline_color( color :Color ) -> void:
	$ScoreLabel.add_theme_color_override("font_outline_color", color)

func _on_animation_finished( _animation_name :String ) -> void:
	queue_free();
