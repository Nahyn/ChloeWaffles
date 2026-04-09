extends Control
class_name AudioParametersControl


func _on_master_parameter_line_volume_changed() -> void:
	_on_sfx_parameter_line_volume_changed();
	_on_voices_parameter_line_volume_changed();

func _on_music_parameter_line_volume_changed() -> void:
	pass # Replace with function body.

func _on_sfx_parameter_line_volume_changed() -> void:
	SoundManager.play_test_sound(SoundManager.AUDIO_BUSES.SFX, get_global_mouse_position())

func _on_voices_parameter_line_volume_changed() -> void:
	SoundManager.play_test_sound(SoundManager.AUDIO_BUSES.VOICE, get_global_mouse_position())

func _on_close_button_pressed() -> void:
	visible = false;
