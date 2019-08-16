extends Control

signal GAME_START_REQUEST

enum CLIENT_ROLE {GUEST, ADMIN, HOST}

var rcbox
var startButton

var game
var player

func _ready():
	$Panel/StartButton.visible = false

func initialize(player, game):
	self.game = game
	self.player = player
	$Panel/InfoBox/RCBox.text = 'Room Code: %s' % str(game.room_code)
	$Panel/InfoBox.color = self.player.color
	
	game.connect('PLAYER_LIST_CHANGE', self, '_player_list_change')

func _player_list_change(players, MIN_PLAYERS, MAX_PLAYERS):
	print('\t> UI update for new player list %s' % str(players))
	$Panel/InfoBox/WFPlayers.text = 'Waiting for Players (%s / %s)' % [str(len(players)-1), str(MIN_PLAYERS-1)]
	#$Panel/PlayerList.text = ''
	#var counter: int = 1
	#for player in players:
	#	var admin_str: String = ''
	#	if player['role'] == CLIENT_ROLE.ADMIN:
	#		admin_str = '{#}'
	#	if player['role'] == CLIENT_ROLE.SCREEN:
	#		admin_str = '{S}'
	#	var player_str = '[%s]: %s %s' % [str(counter), player['nick'], admin_str]
	#	$Panel/PlayerList.text += player_str + '\n'
	#	counter += 1
	
	if len(players) >= self.game.MIN_PLAYERS and self.player.role == CLIENT_ROLE.ADMIN:
		$Panel/StartButton.visible = true
	else:
		$Panel/StartButton.visible = false

func _on_StartButton_pressed():
	emit_signal('GAME_START_REQUEST')

func pre_destroy():
	pass