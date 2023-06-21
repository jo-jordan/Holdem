class_name Room extends Node

var table = Table.new()

func update_players():
	var seatList: Array[Node] = get_node("Seats").get_children()
	for index in range(Global.playerList.size()):
		var seatDest = seatList[index]
		var player = Global.playerList[index]
		seatDest.get_node("Points").text = str(player["chips"])
		seatDest.get_node("Nickname").text = str(player["username"])
		seatDest.get_node("Position").text = str(player["position"])


func _update_room_info(roomInfo):
	Global.playerList = roomInfo["playerInfoList"]
	Global.roomName = roomInfo["roomName"]
	Global.gameConfig = roomInfo["gameConfig"]
	print("_on_room_info_update: ", roomInfo)
	
	update_players()

func _on_room_info_update(data):
	var roomInfo = data["roomInfo"]
	_update_room_info(roomInfo)

func _on_game_ready(data):
	print("_on_game_ready: ", data)
	
func _on_game_start(data):
	$Popup.visible = true
	$Popup/Label.text = "GAME START!"
	print("_on_game_start: ", data)
	var seatList: Array[Node] = get_node("Seats").get_children()
	for seat in seatList:
		for card in seat.get_node("CardList").get_children():
			seat.get_node("CardList").remove_child(card)
			
	var cardsOnDeck = get_node("CardsOnDeck")
	var deckCardList: BoxContainer = cardsOnDeck.get_node("CardList")
	for card in deckCardList.get_children():
		deckCardList.remove_child(card)
		

func _on_game_update_bet(data):
	print("_on_game_update_bet: ", data)
	_update_room_info(data["roomInfo"])
	var seatList: Array[Node] = get_node("Seats").get_children()
	var seatDest = seatList[0]
	var optionContainer: BoxContainer = seatDest.get_node("OptionContainer")
	if data["playerId"] == Global.playerId:
		optionContainer.visible = true
		for child in optionContainer.get_children():
			child.visible = false
		for option in data["operationList"][Global.playerId]:
			if option == "CHECK":
				optionContainer.get_node("CheckButton").visible = true
			if option == "CALL":
				optionContainer.get_node("CallButton").visible = true
			if option == "FOLD":
				optionContainer.get_node("FoldButton").visible = true
			if option == "RAISE":
				optionContainer.get_node("RaiseButton").visible = true
			if option == "ALL_IN":
				optionContainer.get_node("All-InButton").visible = true
			
	else:
		optionContainer.visible = false

func _on_game_deal_player_cards(data):
	var cardsToDealNode: CardsToDeal = get_node("CardsToDeal")
	var seatList: Array[Node] = get_node("Seats").get_children()

	var delay = 0.0
	for times in range(0, 2):
		for index in range(Global.playerList.size()):
			var player = Global.playerList[index]
			var seatDest = seatList[index]
			if player["playerId"] == Global.playerId:
				var cardIndex = data["cards"][times]["id"]
				cardsToDealNode.deal_to_player(cardIndex, seatDest, delay)
			else:
				cardsToDealNode.deal_to_player(53, seatDest, delay)
			delay += 0.5

	print("_on_game_deal_player_cards: ", data)
		

func _deal_to_table(cards):
	var cardsToDealNode: CardsToDeal = get_node("CardsToDeal")
	var cardsOnDeck = get_node("CardsOnDeck")
	for times in range(cards.size()):
		var cardIndex = cards[times]["id"]
		cardsToDealNode.deal_flop_card(cardIndex, cardsOnDeck, 0)
	
	
func _on_game_deal_flop_cards(data):
	print("_on_game_deal_flop_cards: ", data)
	
	var cards = data["cards"]
	_deal_to_table(cards)

func _on_game_deal_turn_cards(data):
	print("_on_game_deal_turn_cards: ", data)
	
	var cards = data["cards"]
	_deal_to_table(cards)
	
func _on_game_deal_river_cards(data):
	print("_on_game_deal_river_cards: ", data)
	
	var cards = data["cards"]
	_deal_to_table(cards)

func _on_game_result(data):
	$Leaderboard.visible = true
	print("_on_game_result: ", data)
	$Leaderboard/Label.text = str("winner: ", data["winner"]["username"], ", win chips: ", data["winner"]["winChips"])

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



func _on_exit_button_pressed():
	var dict = {
		"type": "ROOM_LEAVE",
		"roomId": Global.roomId,
	}
	NetworkHub.send(dict)
	queue_free()

func _hide_option_container():
	var seatList: Array[Node] = get_node("Seats").get_children()
	var seatDest = seatList[0]
	var optionContainer: BoxContainer = seatDest.get_node("OptionContainer")
	optionContainer.visible = false

func _on_check_button_pressed():
	var dict = {
		"type": "GAME_BET",
		"betType": "CHECK",
		"roomId": Global.roomId
	}
	NetworkHub.send(dict)
	_hide_option_container()
	


func _on_call_button_pressed():
	var dict = {
		"type": "GAME_BET",
		"betType": "CALL",
		"roomId": Global.roomId
	}
	NetworkHub.send(dict)
	_hide_option_container()


func _on_fold_button_pressed():
	var dict = {
		"type": "GAME_BET",
		"betType": "FOLD",
		"roomId": Global.roomId
	}
	NetworkHub.send(dict)
	_hide_option_container()


func _on_raise_button_pressed():
	var dict = {
		"type": "GAME_BET",
		"betType": "RAISE",
		"betAmount": 1000, ## TODO
		"roomId": Global.roomId
	}
	NetworkHub.send(dict)
	_hide_option_container()


func _on_all_in_button_pressed():
	var dict = {
		"type": "GAME_BET",
		"betType": "ALL_IN",
		"roomId": Global.roomId
	}
	NetworkHub.send(dict)
	_hide_option_container()
