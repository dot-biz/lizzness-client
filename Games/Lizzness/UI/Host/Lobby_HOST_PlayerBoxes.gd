extends Control
const POSITIONS_10 = [[750,400], [550,250], [1350,400], [950,700], [200,550], [950,250], [1350,500], [550,700], [250,400], [750,550]]
const POSITIONS_17 = [[200,250],[550,250],[900,250],[1250,250],[200,400],[550,400],[900,400],[1250,400],[200,550],[550,550],[900,550],[1250,550],[550,700],[900,700],[350,837],[750,837],[1610,630]] # NOTE: The last entry MUST be rotated -90 degrees in order to fit.

enum CLIENT_ROLE {GUEST, ADMIN, HOST}

var PLAYER_BOX
var current_players_by_id
var current_players_by_position_index
var id_to_position_index

func _ready():
	PLAYER_BOX = load('res://Games/Lizzness/UI/Common/WB-box.tscn')
	current_players_by_id = {}
	current_players_by_position_index = {}
	id_to_position_index = {}

func update_player_list(players):
	# Re-draws the player boxes with the given player-list. Hosts are not drawn; Admins are drawn with the "Boss" annotation; other players are drawn normally.
	# Positions for drawing are determined by the POSITIONS_N arrays, where N is the maximum number of players that this positioning scheme can fit.
	
	if (len(players) == 12 and len(current_players_by_id) <= 12) \
		or (len(players) == 11 and len(current_players_by_id) >= 11):
		# We need to change the organization scheme - delete all boxes and re-make
		for box in current_players_by_id.values():
			box.queue_free()
		current_players_by_id.clear()
		current_players_by_position_index.clear()
		id_to_position_index.clear()
	
	# Choose the appropriate list of positions to use.
	var pos_list = POSITIONS_17
	if len(players) <= 11:
		# NOTE: The HOST also counts as a player, but they will not be displayed on-screen, so 11 players = 10 displayed players.
		pos_list = POSITIONS_10
	
	# Add or update players
	for player in players:
		if player['role'] == CLIENT_ROLE.HOST:
			continue # Ignore the host.
		if player['id'] in current_players_by_id.keys():
			current_players_by_id[ player['id'] ].update_text(
				player['nick'],
				player['role'] == CLIENT_ROLE.ADMIN
			)
			# Note that the update_text() method also sets the UPDATED flag, which we check later to see which players were actually in the new list, so that we
			# can delete those who were NOT in the original list.
		else:
			var box = PLAYER_BOX.instance()
			
			# Determine the first open position
			var dex = 0
			while dex in current_players_by_position_index.keys():
				dex += 1
			
			# Set up initial position, text, color, etc.
			box.set_name(str(player['id']))
			box.rect_position.x = pos_list[dex][0]
			box.rect_position.y = pos_list[dex][1]
			
			if dex == 16:
				# SPECIAL CASE: 17th player must be rotated sideways
				box.rect_rotation = -90
			
			box.modulate = Color(player['color'])
			box.INITIAL_TEXT = player['nick']
			box.IS_BOSS = (player['role'] == CLIENT_ROLE.ADMIN)
			box.UPDATED = true
			
			# Add to arrays
			current_players_by_id[player['id']] = box
			current_players_by_position_index[dex] = box
			id_to_position_index[player['id']] = dex
			
			# Add to tree
			self.add_child(box)
	
	var keys_to_erase = []
	for box in current_players_by_id.keys():
		if not current_players_by_id[box].UPDATED:
			# If this flag is not set, then we did not see this player in the new lists - delete them
			# and prepare to erase them from the dicts.
			keys_to_erase.append(box)
			current_players_by_id[box].queue_free()
		else:
			# Otherwise, make sure to reset the UPDATED flag to false for the next cycle.
			current_players_by_id[box].clear_updated()
	
	for key in keys_to_erase:
		# Erase the keys which now point to deleted objects
		current_players_by_id.erase(key)
		current_players_by_position_index.erase(id_to_position_index[key])
		id_to_position_index.erase(key)