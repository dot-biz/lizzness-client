extends Control

signal SERVER_CONNECT

const HARDCODED_SERVER = 'lizzness-backend.my.homelab'
const HARDCODED_PORT = '12926'

func _ready():
	print('initiating connection to %s port %s' % [HARDCODED_SERVER, HARDCODED_PORT])
	emit_signal('SERVER_CONNECT', HARDCODED_SERVER, HARDCODED_PORT)

func initialize(params):
	pass

func pre_destroy():
	pass