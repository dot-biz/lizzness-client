extends ColorRect

func _ready():
	pass

func _on_NickChange_text_changed(new_text):
	if len(new_text) > 0:
		$AcceptButton.visible = true
		$ClearButton.visible = true
	else:
		$AcceptButton.visible = false
		$ClearButton.visible = false