extends TextureRect

export var INITIAL_TEXT: String
export var IS_BOSS: bool
export var FORCE_TEXTURE: String

var MY_TEXTURES = ['WB-box-1.png', 'WB-box-2.png', 'WB-box-3.png', 'WB-box-4.png', 'WB-box-5.png', 'WB-box-6.png']

var UPDATED = false

func _ready():
	var selected_texture = MY_TEXTURES[(randi() % (len(MY_TEXTURES)-1))+1]
	if FORCE_TEXTURE:
		selected_texture = FORCE_TEXTURE
	self.texture = load('res://Games/Lizzness/Assets/UI/Common/WB-shapes/%s' % selected_texture)
	$Label.text = INITIAL_TEXT
	$BOSS_indicator.visible = IS_BOSS

func update_text(text, is_boss):
	# Sets the text and boss-status for this object. Also sets UPDATED to true (used in player-list
	# operations; e.g. Lobby_HOST_PlayerBoxes.gd:update_player_list()).
	$Label.text = text
	$BOSS_indicator.visible = is_boss
	UPDATED = true

func clear_updated():
	# Clears the UPDATED flag
	UPDATED = false