extends Control

signal GAME_START_REQUEST

enum CLIENT_ROLE {GUEST, ADMIN, HOST}

var plist

var game
var player

func _ready():
	pass

func initialize(player, game):
	self.game = game
	self.player = player
	$RCode.text = str(game.room_code)
	
	game.connect('PLAYER_LIST_CHANGE', self, '_player_list_change')

func _player_list_change(players, MIN_PLAYERS, MAX_PLAYERS):
	print('\t> UI update for new player list %s' % str(players))
	$PlayerBoxes.update_player_list(players)

func pre_destroy():
	pass