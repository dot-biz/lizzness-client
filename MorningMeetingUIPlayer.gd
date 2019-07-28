extends Control

var Header
var Statement

var player
var game

const DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']

func _ready():
	Header = get_node("Panel/Header")
	Statement = get_node("Panel/Statement")
	
func initialize(player, game):
	data_exfiltrated = game.most_recent_state_delta['human_win_count']['change']
	
	self.player = player
	self.game = game
	
	Header.text = "Morning Meeting - %s" % DAYS[game.day_number]
	
	if game.day_number == 0:
		Statement.text = 'AGENDA ITEMS for Monday:\n' \
			+ '1. BOSS on Vacation.\n' \
			+ 'The BOSS is going away this week, to see her family back on Jupiter. She has gathered her ' \
			+ 'closest confidants - i.e. us - to watch over the company while ' \
			+ 'she is away.\n\n' \
			+ '2. Warning from BUILDING SECURITY:\n' \
			+ 'BUILDING SECURITY has warned us about an uptick in the prevalence of troublemaking ' \
			+ 'HUMANS in our midst. Keep your eyes open, friends - the HUMANS can be wily, especially ' \
			+ 'those INVESTIGATIVE JOURNALISTS.\n\n' \
			+ '3. NIGHT WATCHES:\n' \
			+ 'As the inner circle of the BOSS, it is our job to watch over the important company FILE SERVERS ' \
			+ 'each night. Every day, we will elect a few people to serve on the NIGHT WATCH. Take this duty ' \
			+ 'seriously, as HUMANS could try to steal our SECRET COMPANY DATA from the FILE SERVERS.\n\n'
		return
	
	var statement_header = 'The IT lizard has a report to make:\n'
	
	var statement_body = ''
	if data_exfiltrated:
		statement_body = '"Somebody accessed our file-server last night. ' \
			+ 'Confidential files may have been stolen. ' \
			+ 'I believe this was the work of... HUMANS!"'
	else:
		statement_body = '"None of our secure files were compromised last night."\n'
	
	var statement_footer = 'The boss returns in %s days, but the humans only need ' \
		+ 'to compromise our servers %s more times to have enough evidence to ' \
		+ 'expose us.'
	
	if game.human_win_count == 2:
		statement_footer += '\nThe situation has officially been declared an emergency, ' \
			+ 'and the board has been granted the power to dismiss a member by majority ' \
			+ 'vote. Press "Motion to Dismiss" to begin a dismissal vote.'
	
	Statement.text = (statement_header + statement_body + statement_footer) % [5 - game.day_number, 3 - game.human_win_count]
	if game.human_win_count == 2:
		$Panel/Dismiss.visible = true
		#for player in players:
		#	var VotOffButton = preload("res://VoteOff.tscn")
		#	VotOffButton._initialize(player)
		#	VotOffButton.text = player["id"]
		#	$CenterContainer/GridContainer.add_child(VotOffButton)

func pre_destroy():
	pass