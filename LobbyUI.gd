extends Control

signal GAME_START_REQUEST

var RoomID
var rcbox
var startButton

const ListItem = preload("res://ListItem.tscn")

func _ready():
	rcbox = get_node('Panel/RCBox/RCText')
	startButton = get_node('Panel/StartButton')
	startButton.set_disabled(true)

func initialize(gameid):
	rcbox.text = 'Connected to RoomID %s' % gameid

func _player_list_change(players):
	print('\t> UI update for new player list %s' % str(players))
	$Panel/PlayerList.text = ''
	for player in players:
		$Panel/PlayerList.text += str(player['nick']) + '\n'

func _enable_start():
	startButton.set_disabled(false)

func _on_StartButton_pressed():
	
	emit_signal('GAME_START_REQUEST')
