extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var roomNumber
var joinRoom
var createRoom
# Called when the node enters the scene tree for the first time.
func _ready():
	roomNumber = get_node("Panel/RoomNumberLine")
	joinRoom  = get_node("Panel/JoinRoom")
	createRoom = get_node("Panel/CreateRoom")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	passcc
func _on_JoinRoom_pressed():
	if roomNumber.text:
		emit_signal("JOIN_ROOM", roomNumber.text)


func _on_CreateRoom_pressed():
	if createRoom.text:
		emit_signal("CREATE_ROOM")
