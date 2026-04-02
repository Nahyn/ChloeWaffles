extends TextureRect
class_name BatterSqueezer

@export var waffle_maker_target :WaffleMakerNode

const WAFFLE_CHOCOLATE = preload("uid://dl6u3q2t2e82l")
const WAFFLE_MATCHA = preload("uid://d3xi0174b2hs1")
const WAFFLE_PLAIN = preload("uid://dtrukfpdja7cn")


func _on_batter_squeezer_chocolate_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		waffle_maker_target.put_batter(WAFFLE_CHOCOLATE)


func _on_batter_squeezer_matcha_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		waffle_maker_target.put_batter(WAFFLE_MATCHA)


func _on_batter_squeezer_plain_gui_input(event: InputEvent) -> void:
	if EventManager.is_event_left_click(event):
		waffle_maker_target.put_batter(WAFFLE_PLAIN)
