extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Header
var DummyText
var Time
# Called when the node enters the scene tree for the first time.
func _ready():
	Header = get_node('Panel/Header')
	DummyText = get_node('Panel/DummyText')
	Time = get_node('Panel/ColorRect/Time')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _initialize(day, numpeople, playername):
	Header.text = 'Day %s | Workday' % [str(day)]
	DummyText.text = 'At 5:00PM %s\n\t> will choose %s people for the night shift' % [str(playername), str(numpeople)]
	
func _updateTimer(time):
	Time.text = time

func pre_destroy():
	pass