extends Button

var player_id
signal PLAYER_PRESSED

func _ready():
	pass # Replace with function body.
	
func _initialize(player):
	player_id = player['id']

func _on_Button_pressed():
	emit_signal('PLAYER_PRESSED',player_id)
