extends Node

signal PLAYER_LIST_CHANGE

var room_code: int
var connected_players = []

func _ready():
	pass

func initialize(room_code: int):
	self.room_code = room_code

remote func update_player_list(pkt):
	print('Player list change - new list %s' % str(pkt['players']))
	connected_players = pkt['players']
	emit_signal('PLAYER_LIST_CHANGE', connected_players)