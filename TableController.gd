extends Control

class_name TableController



var table = Table.new()

func init():
	init_deck_on_table()
	init_players()

func init_deck_on_table():
	pass
	
func init_players():
	pass

func get_player_list():
	return [
		Player.new(1, "test1", 1, true), \
		Player.new(2, "test2", 2), \
		Player.new(3, "test3", 3), \
		Player.new(4, "test4", 4), \
		Player.new(5, "test5", 5), \
		Player.new(6, "test6", 6), \
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	
	var deck = DeckUtils.new()
	var cardsToDealNode: CardsToDeal = get_node("CardsToDeal")
	var playerList = get_player_list()
	var seatList = get_node("Seats").get_children()
	
	
	var delay = 0.0
	for times in range(0, 2):
		for player in playerList: 
			var p = player as Player
			var seatDest = seatList[p.seat - 1]
			var cardIndex = deck.deal()
			cardsToDealNode.deal_to_player(p.seat, cardIndex, seatDest, delay)
			delay += 0.5
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_pressed():
	queue_free()
