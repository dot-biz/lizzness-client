extends Control

var Header
var Statement

# Called when the node enters the scene tree for the first time.
func _ready():
	Header = get_node('Panel/Header')
	Statement = get_node('Panel/Statement')
	
func _initialize(day, numpeople, players):
	Header.text = 'Day %s | End-Of-Day' % str(day)
	Statement.text = 'Choose %s people for the Night Shift' % str(numpeople)
	
	for player in players:
		var PlayerButton = preload("res://PlayerButton.tscn").instance()
		PlayerButton._initialize(player)
		$Panel/CenterContainer/GridContainer.add_child(PlayerButton)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
