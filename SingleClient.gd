extends Node

var id

func _ready():
	pass

func initialize(id):
	self.id = id

func join_room(room_code):
	rpc_id(1, 'join_room', room_code)

func create_room(game_name):
	rpc_id(1, 'create_room', game_name)