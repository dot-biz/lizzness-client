extends Control


var exfiltrateButton
var notexfiltrateButton
var nightlabel
var time
signal EXFILTRATE_PRESSED
signal NOT_EXFILTRATE_PRESSED
# Called when the node enters the scene tree for the first time.
func _ready():
	exfiltrateButton = get_node("Panel/Exfiltrate")
	notexfiltrateButton = get_node("Panel/NotExfiltrate")
	nightlabel = get_node("Panel/Label")
	time = get_node("Panel/ColorRect/Label")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exfiltrate_pressed():
	emit_signal("EXFILTRATE_PRESSED") # Replace with function body.


func _on_NotExfiltrate_pressed():
	emit_signal("NOT_EXFILTRATE_PRESSED") # Replace with function body.
