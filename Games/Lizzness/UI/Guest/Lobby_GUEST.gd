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
	$Panel/InfoBox/NickChange.placeholder_text = self.player.nick
	
	
	if len(players) >= self.game.MIN_PLAYERS and self.player.role == CLIENT_ROLE.ADMIN:
		$Panel/StartButton.visible = true
	else:
		$Panel/StartButton.visible = false

func _on_StartButton_pressed():
	emit_signal('GAME_START_REQUEST')

func pre_destroy():
	pass

func _ui_nick_change_request(new_text):
	self.game.do_nick_change(new_text)
	$Panel/InfoBox/NickChange.text = ''
	$Panel/InfoBox/AcceptButton.visible = false
	$Panel/InfoBox/ClearButton.visible = false


func _on_AcceptButton_pressed():
	_ui_nick_change_request($Panel/InfoBox/NickChange.text)


func _on_ClearButton_pressed():
	$Panel/InfoBox/NickChange.text = ''
	$Panel/InfoBox/AcceptButton.visible = false
	$Panel/InfoBox/ClearButton.visible = false
