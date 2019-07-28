extends Node

signal PLAYER_LIST_CHANGE
signal GAME_STATE_CHANGED

export var MIN_PLAYERS: int = 2
export var MAX_PLAYERS: int = 8

enum {STATE_LOBBY, STATE_PLAYING, STATE_DISSOLVING}
enum {GAME_DAY_MORNING, GAME_DAY_WORKDAY, GAME_DAY_AFTERNOON, GAME_DAY_MIDNIGHT}
enum CLIENT_ROLE {PLAYER, ADMIN, SCREEN}
var game_state: int
var day_number: int
var day_state: int

var player

var room_code: int
var connected_players = []

func _ready():
	pass

func initialize(player, room_code: int):
	self.player = player
	self.room_code = room_code

remote func update_player_list(pkt):
	print('Player list change - new list %s' % str(pkt['players']))
	connected_players = pkt['players']
	for player in connected_players:
		if int(player['id']) == int(self.player.id):
			self.player.role = player['role']
			self.player.nick = player['nick']
	emit_signal('PLAYER_LIST_CHANGE', connected_players, MIN_PLAYERS, MAX_PLAYERS)

func _game_start_request():
	if player.role == CLIENT_ROLE.ADMIN and len(connected_players) >= MIN_PLAYERS:
		rpc_id(1, 'start_game')

remote func game_state_change(game_state, day_number, day_state):
	self.game_state = game_state
	self.day_number = day_number
	self.day_state = day_state
	emit_signal('GAME_STATE_CHANGED', game_state, day_number, day_state)