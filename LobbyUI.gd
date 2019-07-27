extends Control

var RoomID
var rcbox
var PC
var startButton
var listIndex = 0
const ListItem = preload("res://ListItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rcbox = get_node('Panel/RCBox/RCText')
	PC = get_node('Panel/PC/PCText')
	startButton = get_node('Panel/StartButton')
	startButton.set_disabled(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initialize(gameid):
	rcbox.text = 'Connected to RoomID %s' % gameid
	
	
func addItem(value):
	var item = ListItem.instance()
	item.get_node("number").text = str( listIndex )
	item.get_node("label").text = value
	item.rect_min_size = Vector2(320,22)
	$ScrollContainer/list.add_child(item)
	
func update_players(players):
	$ScrollContainer/list.queue_free()
	for player in players:
		addItem(player['nick'])
	
