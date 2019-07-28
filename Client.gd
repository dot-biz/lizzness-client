extends Node

signal PLAYER_LIST_CHANGE
signal ENABLE_START

var server_cx
var client_obj

func _ready():
	var clients =  Node.new()
	clients.set_name('clients')
	
	var games = Node.new()
	games.set_name('games')
	
	var connect_ui = preload('res://ConnectUI.tscn').instance()
	connect_ui.connect('SERVER_CONNECT', self, '_attempt_server_connect')
	connect_ui.set_name('UI')
	
	get_tree().connect('connection_failed', self, '_cx_end')
	get_tree().connect('network_peer_connected', self, '_network_peer_connected')
	
	get_tree().get_root().call_deferred('add_child', clients)
	get_tree().get_root().call_deferred('add_child', games)
	get_tree().get_root().call_deferred('add_child', connect_ui)

func _attempt_server_connect(address, port):
	print('Attempting to connect to %s port %s' % [address, port])
	server_cx = WebSocketClient.new()
	server_cx.connect_to_url('ws://%s:%s' % [str(address), str(port)], PoolStringArray(), true)
	get_tree().set_network_peer(server_cx)

func _network_peer_connected(id):
	var own_id = get_tree().get_network_unique_id()
	print('Connected to new peer with id %s. Our network id is %s.' % [str(id), str(own_id)])
	if id == 1:
		print('\t> Connected to server. Creating client object at /clients/%s' % str(own_id))
		client_obj = preload('res://SingleClient.tscn').instance()
		client_obj.set_name(str(own_id))
		client_obj.connect('ROOM_JOINED', self, '_room_joined')
		get_node('/root/clients').add_child(client_obj)
		client_obj.initialize(id) #client object is each user
		
		var old_ui = get_node('/root/UI')
		old_ui.set_name('UI_UNLOADNIG')
		old_ui.queue_free()
		var rs_ui = preload('res://RoomSelectUI.tscn').instance()
		rs_ui.set_name('UI')
		rs_ui.connect('JOIN_ROOM', self, '_request_join_room')
		rs_ui.connect('CREATE_ROOM', self, '_request_create_room')
		get_tree().get_root().add_child(rs_ui)

func _cx_end():
	print('Connection ended!')

func _request_join_room(room_code):
	print('Requesting to join room %s' % str(room_code))
	client_obj.join_room(room_code)

func _room_joined(room_code):
	print('Server order to join room %s' % str(room_code))
	var old_ui = get_node('/root/UI')
	old_ui.set_name('UI_UNLOADING')
	var new_ui = preload('res://LobbyUI.tscn').instance()
	new_ui.set_name('UI')
	self.connect('ENABLE_START', new_ui, '_enable_start')
	get_tree().get_root().add_child(new_ui)
	new_ui.initialize(room_code)

func _request_create_room(game_name):
	print('Requesting new room for %s' % game_name)
	client_obj.create_room(game_name)

func _process(delta):
	if not server_cx:
		return
	
	if server_cx.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED \
	or server_cx.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING:
		server_cx.poll()