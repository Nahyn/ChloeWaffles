extends Node

signal screen_moved()
signal bell_clicked()
signal waffle_clicked( waffle_node :WaffleNode )
signal stockpile_clicked( stockpile :IngredientStockpileNode )
signal client_clicked( character_node :CharacterNode )

signal trash_clicked()

signal waffle_trashed( ingredients :Array[IngredientResource] )
signal client_served( ingredients :Array[IngredientResource], modifiers :Array[float] )
signal client_missed()
signal waffle_burnt()

func is_event_click( event :InputEvent ) -> bool:
	return (event is InputEventMouseButton and event.is_pressed());
	
func is_event_left_click( event :InputEvent ) -> bool:
	if not is_event_click(event):
		return false;
	
	event = event as InputEventMouseButton;
	if not event.button_index == MOUSE_BUTTON_LEFT:
		return false;
	
	return true;

func is_event_right_click( event :InputEvent ) -> bool:
	if not is_event_click(event):
		return false;
	
	event = event as InputEventMouseButton;
	if not event.button_index == MOUSE_BUTTON_RIGHT:
		return false;
	
	return true;
