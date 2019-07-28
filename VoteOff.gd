extends Button

var player_id
signal PLAYER_VOTED_OFF

func _ready():
	pass # Replace with function body.
	
func _initialize(player):
	player_id = player['id']

func _on_VotOff_pressed():
	emit_signal('PLAYER_VOTED_OFF',player_id)
