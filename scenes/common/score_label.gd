extends Control
class_name ScoreLabel

var text := "":
	set( _text ):
		text = _text
		if $ScoreLabel != null:
			$ScoreLabel.text = text;


func _on_animation_finished( _animation_name :String ) -> void:
	queue_free();
