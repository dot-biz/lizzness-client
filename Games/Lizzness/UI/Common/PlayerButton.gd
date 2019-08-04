extends Button

func _ready():
	pass

func initialize(player):
	self.text = player['nick']