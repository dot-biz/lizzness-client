extends Control

signal GAME_START_REQUEST

enum CLIENT_ROLE {PLAYER, ADMIN, SCREEN}

var rcbox
var startButton

var game
var player

const ListItem = preload("res://ListItem.tscn")

func _ready():
	rcbox = get_node('Panel/RCBox/RCText')
	startButton = get_node('Panel/StartButton')
	startButton.visible = false

func initialize(player, game):
	self.game = game
	self.player = player
	rcbox.text = 'Connected to RoomID %s' % str(game.room_code)

func _player_list_change(players, MIN_PLAYERS, MAX_PLAYERS):
	print('\t> UI update for new player list %s' % str(players))
	$Panel/PlayerList.text = ''
	var counter: int = 1
	for player in players:
		var admin_str: String = ''
		if player['role'] == CLIENT_ROLE.ADMIN:
			admin_str = '{#}'
		if player['role'] == CLIENT_ROLE.SCREEN:
			admin_str = '{S}'
		var player_str = '[%s]: %s %s' % [str(counter), player['nick'], admin_str]
		$Panel/PlayerList.text += player_str + '\n'
		counter += 1
	
	if len(players) >= game.MIN_PLAYERS and player.role == CLIENT_ROLE.ADMIN:
		startButton.visible = true

func _on_StartButton_pressed():
	emit_signal('GAME_START_REQUEST')