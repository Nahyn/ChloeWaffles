extends Node

enum AUDIO_BUSES {
	MAIN,
	MUSIC,
	SFX,
	VOICE
}

@export var music_by_screen :Dictionary[SceneManager.SCREEN_TYPES, AudioStream] = {}

const SFX_BELL_ENTRY = preload("res://assets/audio/freesound_community-shop-door-bell-6405 - entry.wav")
const SFX_BELL_EXIT = preload("res://assets/audio/freesound_community-shop-door-bell-6405 - exit.wav")
const SFX_POP = preload("res://assets/audio/creatorshome-pop-cartoon-328167.mp3")
const SFX_SMOKE_ALARM = preload("res://assets/audio/smoke_detector.wav")
const SFX_SPLAT = preload("res://assets/audio/freesound_community-cartoon-splat-6086.mp3")

@export var pitch_range := 0.05;

var playing_audioplayers :Array[AudioStreamPlayer2D] = []
var available_audioplayers :Array[AudioStreamPlayer2D] = []

var looping_audioplayers :Dictionary[Vector2, AudioStreamPlayer2D] = {}
var _playing_audioplayers_func :Dictionary[AudioStreamPlayer2D, Callable] = {}

func _ready() -> void:
	if %SfxPlayers == null:
		return
	available_audioplayers.clear();
	
	play_music(SceneManager.SCREEN_TYPES.MAIN_MENU);
	
	for audioplayer in %SfxPlayers.get_children():
		audioplayer = audioplayer as AudioStreamPlayer2D
		available_audioplayers.push_back(audioplayer);

func play_music( screen :SceneManager.SCREEN_TYPES ) -> void:
	if not music_by_screen.has(screen):
		return
	%AudioStreamPlayer.stream = music_by_screen[screen]
	%AudioStreamPlayer.play()

func _get_randomised_pitch() -> float:
	return 1.0 + randf_range(-pitch_range, pitch_range);

func play_test_sound( audio_bus :AUDIO_BUSES, target_global_position :Vector2 ) -> void:
	var audioplayer = _get_audioplayer();
	audioplayer.bus = AudioServer.get_bus_name(audio_bus);
	
	available_audioplayers.erase(audioplayer);
	playing_audioplayers.push_back(audioplayer);
	
	var callback := _on_audioplayer_finished.bind(audioplayer)
	_playing_audioplayers_func[audioplayer] = callback
	audioplayer.finished.connect( callback )
	
	audioplayer.stream = SFX_POP;
	audioplayer.global_position = target_global_position;
	audioplayer.pitch_scale = _get_randomised_pitch();
	audioplayer.play()

func _get_audioplayer() -> AudioStreamPlayer2D:
	var audioplayer = available_audioplayers.pop_front();
	
	if audioplayer == null:
		audioplayer = playing_audioplayers.pop_front()
	
	return audioplayer;

func _play_looping_sound(stream :AudioStream, target_global_position :Vector2) -> void:
	var audioplayer = _get_audioplayer();
	
	available_audioplayers.erase(audioplayer);
	looping_audioplayers[target_global_position] = audioplayer;
	
	var callback := _on_looping_audioplayer_finished.bind(audioplayer)
	_playing_audioplayers_func[audioplayer] = callback
	audioplayer.finished.connect( callback )
	
	audioplayer.stream = stream;
	audioplayer.global_position = target_global_position;
	audioplayer.pitch_scale = _get_randomised_pitch();
	audioplayer.play()

func _stop_looping_sound(target_global_position :Vector2) -> void:
	if not looping_audioplayers.has(target_global_position):
		return
	
	var audioplayer = looping_audioplayers[target_global_position]
	looping_audioplayers.erase(target_global_position);
	_on_audioplayer_finished(audioplayer);

func _play_sound_at( stream :AudioStream, target_global_position :Vector2 ) -> void:
	var audioplayer = _get_audioplayer();
	audioplayer.bus = AudioServer.get_bus_name(AUDIO_BUSES.SFX);
	
	available_audioplayers.erase(audioplayer);
	playing_audioplayers.push_back(audioplayer);
	
	var callback := _on_audioplayer_finished.bind(audioplayer)
	_playing_audioplayers_func[audioplayer] = callback
	audioplayer.finished.connect( callback )
	
	audioplayer.stream = stream;
	audioplayer.global_position = target_global_position;
	audioplayer.pitch_scale = _get_randomised_pitch();
	audioplayer.play()

func _on_looping_audioplayer_finished( audioplayer :AudioStreamPlayer2D ) -> void:
	audioplayer.play()

func _on_audioplayer_finished( audioplayer :AudioStreamPlayer2D ) -> void:
	audioplayer.finished.disconnect(_playing_audioplayers_func[audioplayer]);
	_playing_audioplayers_func.erase(audioplayer)
	
	audioplayer.playing = false;
	playing_audioplayers.erase(audioplayer);
	available_audioplayers.push_back(audioplayer);

func play_entry_sound( target_global_position :Vector2 ) -> void:
	_play_sound_at(
		[SFX_BELL_ENTRY].pick_random(),
		target_global_position
	)
func play_exit_sound( target_global_position :Vector2 ) -> void:
	_play_sound_at(
		[SFX_BELL_EXIT].pick_random(),
		target_global_position
	)
func play_splat_sound( target_global_position :Vector2 ) -> void:
	_play_sound_at(
		[SFX_SPLAT].pick_random(),
		target_global_position
	)
func play_pop_sound( target_global_position :Vector2 ) -> void:
	_play_sound_at(
		[SFX_POP].pick_random(),
		target_global_position
	)
func play_alarm_sound(target_global_position :Vector2) -> void:
	_play_sound_at(
		[SFX_SMOKE_ALARM].pick_random(),
		target_global_position
	)
func play_looping_alarm_sound(target_global_position :Vector2) -> void:
	_play_looping_sound(
		[SFX_SMOKE_ALARM].pick_random(),
		target_global_position
	)
func stop_looping_alarm_sound(target_global_position :Vector2) -> void:
	_stop_looping_sound(target_global_position)

func change_volume( audio_bus :int, volume :float ) -> void:
	AudioServer.set_bus_volume_linear(audio_bus, volume);
func set_mute_bus( audio_bus :int, state :bool ) -> void:
	AudioServer.set_bus_mute(audio_bus, state);
