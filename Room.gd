class_name Room extends Node

var table = Table.new()

func update_players():
	var l: Array = []
	l.pop_front()
	for index in range(Global.playerList.size()):
		var player = Global.playerList[index]
		var playerId = player["playerId"]
		if Global.playerId == playerId:
			for i in range(index + 1):
				var p = Global.playerList.pop_front()
				Global.playerList.append(p)
			break
	
	var seatList: Array[Node] = get_node("Seats").get_children()
	for index in range(Global.playerList.size()):
		var seatDest = seatList[index]
		var player = Global.playerList[index]
#		seatDest.get_node("Points").text = str(player["chips"])
		seatDest.get_node("Nickname").text = str(player["username"])
		seatDest.get_node("Position").text = str(player["position"])
	

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


func _on_room_info_update(data):
	var roomInfo = data["roomInfo"]
	Global.playerList = roomInfo["playerInfoList"]
	Global.roomName = roomInfo["roomName"]
	Global.gameConfig = roomInfo["gameConfig"]
	print("_room_joined: ", data)
	
	update_players()

func _on_game_ready(data):
	print("_on_game_ready: ", data)
	
func _on_game_start(data):
	$Popup.visible = true
	$Popup/Label.text = "GAME START!"

func _on_game_update_bet(data):
	print("_on_game_update_bet: ", data)

func _on_game_deal_player_cards(data):
	print("_on_game_deal_player_cards: ", data)
	var seatList: Array[Node] = get_node("Seats").get_children()
	for index in range(Global.playerList.size()):
		var seatDest = seatList[index]
		var player = Global.playerList[index]
#		seatDest.get_node("Points").text = str(player["chips"])
		seatDest.get_node("CardList").text = str(player["username"])
		
	
	
func _on_game_deal_flop_cards(data):
	print("_on_game_deal_flop_cards: ", data)

func _on_game_deal_turn_cards(data):
	print("_on_game_deal_turn_cards: ", data)
	
func _on_game_deal_river_cards(data):
	print("_on_game_deal_river_cards: ", data)

func _on_game_result(data):
	print("_on_game_result: ", data)

func auto_ready():
	var dict = {
		"type": "GAME_READY",
		"playerId": Global.playerId,
		"roomId": Global.roomId
	}
	NetworkHub.send(dict)

func _ready():
	NetworkHub.room_joined.connect(_on_room_info_update)
	NetworkHub.room_leaved.connect(_on_room_info_update)
	NetworkHub.game_ready.connect(_on_game_ready)
	NetworkHub.game_start.connect(_on_game_start)
	NetworkHub.game_update_bet.connect(_on_game_update_bet)
	NetworkHub.game_deal_player_cards.connect(_on_game_deal_player_cards)
	NetworkHub.game_deal_flop_cards.connect(_on_game_deal_flop_cards)
	NetworkHub.game_deal_turn_cards.connect(_on_game_deal_turn_cards)
	NetworkHub.game_deal_river_cards.connect(_on_game_deal_river_cards)
	NetworkHub.game_result.connect(_on_game_result)
	
	auto_ready()
	
#	deal_cards_to_players()
#
#	deal_flop()
#	deal_turn()
#	deal_river()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_pressed():
	var dict = {
		"type": "ROOM_LEAVE",
	}
	NetworkHub.send(dict)
	queue_free()
