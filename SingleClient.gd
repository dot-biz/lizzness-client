extends Node

signal ROOM_JOINED

var id

func _ready():
	pass

func initialize(id):
	self.id = id

func join_room(room_code):
	rpc_id(1, 'join_room', room_code)

func create_room(game_name):
	rpc_id(1, 'create_room', game_name)

remote func create_game_response(pkt):
	pass

remote func join_game_response(pkt):
	# Create /root/games/<id>
	# call initialize(<id>) on that node
	# emit ROOM_JOINED signal
	pass