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
	roomNumber = get_node("RoomNumberLine")
	joinRoom  = get_node("JoinRoom")
	createRoom = get_node("CreateRoom")
	
	
	
func _on_JoinButton_pressed(room_code):
	if roomNumber.text:
		emit_signal("JOIN_ROOM", room_code)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass