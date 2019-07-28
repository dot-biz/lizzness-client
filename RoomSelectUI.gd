extends Control

signal JOIN_ROOM
signal CREATE_ROOM

var roomNumber
var joinRoom
var createRoom

func _ready():
	roomNumber = get_node("Panel/RoomNumberLine")
	joinRoom  = get_node("Panel/JoinRoom")
	createRoom = get_node("Panel/CreateRoom")

func _on_JoinRoom_pressed():
	if roomNumber.text:
		emit_signal("JOIN_ROOM", int(roomNumber.text))

func _on_CreateRoom_pressed():
	if createRoom.text:
		emit_signal("CREATE_ROOM", "Lizzness")

func pre_destroy():
	pass

func _on_RoomNumberLine_text_entered(new_text):
	emit_signal("JOIN_ROOM", int(new_text))