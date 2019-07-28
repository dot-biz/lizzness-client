extends Control

var Header
var Statement

# Called when the node enters the scene tree for the first time.
func _ready():
	Header = get_node("Panel/Label")
	Statement = get_node("Panel/Label2")
	
func _initialize(day, numofinfiltrated, players):
	Header.text = "Morning Meeting %s" % str(day)
	Statement.text = "%s of Data was infiltrated" % str(numofinfiltrated)
	if numofinfiltrated >= 2:
		for player in players:
			var VotOffButton = preload("res://VoteOff.tscn")
			VotOffButton._initialize(player)
			VotOffButton.text = player["id"]
			$CenterContainer/GridContainer.add_child(VotOffButton)