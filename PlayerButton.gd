extends Button

var player_id
signal PLAYER_PRESSED
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _initialize(player):
	player_id = player['id']

func _on_Button_pressed():
	emit_signal('PLAYER_PRESSED',player_id)
