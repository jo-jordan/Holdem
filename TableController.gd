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

func get_player_list() -> Array[Variant]:
	return [
		Player.new(1, "test1", 1, true), \
		Player.new(2, "test2", 2), \
		Player.new(3, "test3", 3), \
		Player.new(4, "test4", 4), \
		Player.new(5, "test5", 5), \
		Player.new(6, "test6", 6), \
	];

func deal_cards_to_players():
	var deck: DeckUtils = DeckUtils.new()
	var cardsToDealNode: CardsToDeal = get_node("CardsToDeal")
	var playerList: Array[Variant] = get_player_list()
	var seatList: Array[Node] = get_node("Seats").get_children()

	var delay = 0.0
	for times in range(0, 2):
		for player in playerList:
			var p: Player = player as Player
			var seatDest = seatList[p.seat - 1]
			var cardIndex = deck.deal()
			cardsToDealNode.deal_to_player(cardIndex, seatDest, delay)
			delay += 0.5


func deal_flop():
	var deck = DeckUtils.new()
	var cardsToDealNode: CardsToDeal = get_node("CardsToDeal")
	var cardsOnDeck = get_node("CardsOnDeck")
	var delay = 7.0
	for times in range(0, 3):
		var cardIndex = deck.deal()
		cardsToDealNode.deal_flop_card(cardIndex, cardsOnDeck, delay)
		delay += 0.5

func deal_turn():
	var deck = DeckUtils.new()
	var cardsToDealNode: CardsToDeal = get_node("CardsToDeal")
	var cardsOnDeck = get_node("CardsOnDeck")
	var delay = 9.0
	var cardIndex = deck.deal()
	cardsToDealNode.deal_turn_card(cardIndex, cardsOnDeck, delay)

func deal_river():
	var deck = DeckUtils.new()
	var cardsToDealNode: CardsToDeal = get_node("CardsToDeal")
	var cardsOnDeck = get_node("CardsOnDeck")
	var delay = 10.0
	var cardIndex = deck.deal()
	cardsToDealNode.deal_river_card(cardIndex, cardsOnDeck, delay)

func _ready():
	init()
	deal_cards_to_players()
	
	deal_flop()
	deal_turn()
	deal_river()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_pressed():
	queue_free()
