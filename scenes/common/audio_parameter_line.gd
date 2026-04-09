extends PanelContainer
class_name AudioParameterLine

@export var audio_bus :SoundManager.AUDIO_BUSES

signal volume_changed()

func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	%TitleCheckBox.text = AudioServer.get_bus_name(audio_bus);
	%TitleCheckBox.set_pressed_no_signal(not AudioServer.is_bus_mute(audio_bus));
	%HSlider.value = AudioServer.get_bus_volume_linear(audio_bus) * 100;
	%ValueLabel.text = str(int(%HSlider.value),"%");

func _on_h_slider_value_changed(value: float) -> void:
	%ValueLabel.text = str(int(value),"%");
	SoundManager.change_volume(audio_bus, value/100.0);
	if visible:
		volume_changed.emit();

func _on_title_check_box_toggled(toggled_on: bool) -> void:
	SoundManager.set_mute_bus(audio_bus, !toggled_on);
