extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_id
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _initialize(player):
	this.text = player['nick']
	player_id = plaer['id']

func _on_Button_pressed():
	emit_signal('PLAYER_PRESSED',player_id)
