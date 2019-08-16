extends Node

signal ROOM_JOINED

var id
var nick
var role
var color

func _ready():
	pass

func initialize(id):
	self.id = id

func join_room(room_code):
	rpc_id(1, 'join_room', room_code)

func create_room(game_name):
	rpc_id(1, 'create_room', game_name)

remote func create_game_response(pkt):
	print('Received game-create confirmation from server.\n\t> %s' % str(pkt))

remote func join_game_response(pkt):
	print('Received game-join confirmation from server.\n\t> %s' % str(pkt))
	
	assert pkt['player']['id'] == self.id
	self.nick = pkt['player']['nick']
	self.role = pkt['player']['role']
	self.color = pkt['player']['color']
	
	var game_node = preload('res://Games/Lizzness/Lizzness.tscn').instance()
	game_node.set_name(str(pkt['room_code']))
	
	get_node('/root/games').add_child(game_node)
	get_node('/root/Client').set_game(game_node)
	game_node.initialize(self, pkt['room_code'])
	emit_signal('ROOM_JOINED', pkt['room_code'])