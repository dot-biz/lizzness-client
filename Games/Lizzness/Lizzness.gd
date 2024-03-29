extends Node

signal PLAYER_LIST_CHANGE
signal GAME_STATE_CHANGED

export var MIN_PLAYERS: int = 5
export var MAX_PLAYERS: int = 18

enum {STATE_LOBBY, STATE_PLAYING, STATE_DISSOLVING}
enum {GAME_DAY_MORNING, GAME_DAY_WORKDAY, GAME_DAY_AFTERNOON, GAME_DAY_MIDNIGHT}
enum CLIENT_ROLE {GUEST, ADMIN, HOST}

var game_state: int
var day_number: int
var day_state: int
var human_win_count: int

var most_recent_state_delta

var player

var room_code: int
var connected_players = []

func _ready():
	pass

func initialize(player, room_code: int):
	self.player = player
	self.room_code = room_code
	
	var ui = null
	
	if player['role'] == CLIENT_ROLE.HOST:
		ui = get_node('/root/Client').ui_change('res://Games/Lizzness/UI/Host/Lobby_HOST.tscn')
	else:
		ui = get_node('/root/Client').ui_change('res://Games/Lizzness/UI/Guest/Lobby_GUEST.tscn')

remote func update_player_list(pkt):
	print('Player list change - new list %s' % str(pkt['players']))
	connected_players = pkt['players']
	for player in connected_players:
		if int(player['id']) == int(self.player.id):
			self.player.role = player['role']
			self.player.nick = player['nick']
	emit_signal('PLAYER_LIST_CHANGE', connected_players, MIN_PLAYERS, MAX_PLAYERS)

func do_nick_change(new_nick):
	rpc_id(1, 'change_nick', new_nick)

func _game_start_request():
	if player.role == CLIENT_ROLE.ADMIN and len(connected_players) >= MIN_PLAYERS:
		rpc_id(1, 'start_game')

remote func game_state_change(game_state, day_number, day_state, human_win_count):
	var state_delta = {
		'game_state':{'change':false},
		'day_number':{'change':false},
		'day_state':{'change':false},
		'human_win_count':{'change':false},
	}
	if game_state != self.game_state:
		state_delta['game_state'] = {'change':true,'old':self.game_state,'new':game_state}
	if day_number != self.day_number:
		state_delta['day_number'] = {'old':self.day_number,'new':day_number}
	if day_state != self.day_state:
		state_delta['day_state'] = {'old':self.day_state,'new':day_state}
	if human_win_count != self.human_win_count:
		state_delta['human_win_count'] = {'old':self.human_win_count,'new':human_win_count}
	
	most_recent_state_delta = state_delta
	
	self.game_state = game_state
	self.day_number = day_number
	self.day_state = day_state
	self.human_win_count = human_win_count
	
	emit_signal('GAME_STATE_CHANGED', game_state, day_number, day_state)
	if player.role == CLIENT_ROLE.HOST:
		do_host_role_ui_change(state_delta)
	else:
		do_guest_role_ui_change(state_delta)

func do_host_role_ui_change(state_delta):
	var ui_base = 'res://Games/Lizzness/UI/Host/%s'
	if state_delta['day_state']['change']:
		if state_delta['day_state']['new'] == GAME_DAY_MORNING:
			get_node('/root/Client').ui_change(ui_base % 'MorningMeeting_HOST.tscn')
		elif state_delta['day_state']['new'] == GAME_DAY_WORKDAY:
			get_node('/root/Client').ui_change(ui_base % 'Workday_HOST.tscn')
		elif state_delta['day_state']['new'] == GAME_DAY_AFTERNOON:
			get_node('/root/Client').ui_change(ui_base % 'AfternoonMeeting_HOST.tscn')
		else:
			get_node('/root/Client').ui_change(ui_base % 'Night_HOST.tscn')

func do_guest_role_ui_change(state_delta):
	var ui_base = 'res://Games/Lizzness/UI/Guest/%s'
	if state_delta['day_state']['change']:
		if state_delta['day_state']['new'] == GAME_DAY_MORNING:
			get_node('/root/Client').ui_change(ui_base % 'MorningMeeting_GUEST.tscn')
		elif state_delta['day_state']['new'] == GAME_DAY_WORKDAY:
			get_node('/root/Client').ui_change(ui_base % 'Workday_GUEST.tscn')
		elif state_delta['day_state']['new'] == GAME_DAY_AFTERNOON:
			get_node('/root/Client').ui_change(ui_base % 'AfternoonMeeting_GUEST.tscn')
		else:
			get_node('/root/Client').ui_change(ui_base % 'Night_GUEST.tscn')