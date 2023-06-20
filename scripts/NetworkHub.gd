extends Dispatcher

signal on_ws_connected

var connectSignalEmitted = false
var isConnected = false
var websocket_game_url = "wss://holdem-game.edgeless.me"

# Our WebSocketClient instance
var scoket_game = WebSocketPeer.new()
var timer = Timer.new()

func _ready():
	add_child(timer)
	timer.timeout.connect(_on_ws_timer_timeout)
	timer.autostart = true
	timer.wait_time = 0.1
	timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	timer.start()

func _room_searched(data):
	pass

func connect_to_ws():
	var headers = PackedStringArray([str("X-Player-Id:", Global.playerId)])
	scoket_game.set_handshake_headers(headers)
	scoket_game.connect_to_url(websocket_game_url)

func _process(delta):
	_game_process()

func _game_process():
	if !isConnected: return
	scoket_game.poll()
	var state = scoket_game.get_ready_state()
	
	if state == WebSocketPeer.STATE_OPEN:
		
		while scoket_game.get_available_packet_count():
			var packet = scoket_game.get_packet().get_string_from_utf8()
			print("Packet: ", packet)
			var data = JSON.parse_string(packet)
			match data["type"]:
				"ROOM_JOIN": 
					room_joined.emit(data)
					break
				"ROOM_CREATE": 
					room_created.emit(data)
					break
				"ROOM_SEARCH": 
					room_searched.emit(data)
					break
				"GAME_READY":
					game_ready.emit(data)
					break
				"GAME_UPDATE_BET":
					game_update_bet.emit(data)
					break
				"GAME_START":
					game_start.emit(data)
					break
				"GAME_DEAL_PLAYER_CARDS":
					game_deal_player_cards.emit(data)
					break
				"GAME_DEAL_FLOP_CARDS":
					game_deal_flop_cards.emit(data)
					break
				"GAME_DEAL_TURN_CARDS":
					game_deal_turn_cards.emit(data)
					break
				"GAME_DEAL_RIVER_CARDS":
					game_deal_river_cards.emit(data)
					break
				"GAME_RESULT":
					game_result.emit(data)
					break
		
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = scoket_game.get_close_code()
		var reason = scoket_game.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.

	
func send(dict):
	scoket_game.send_text(JSON.stringify(dict))

func _on_ws_timer_timeout():
	scoket_game.poll()
	if scoket_game.get_ready_state() == WebSocketPeer.STATE_OPEN:
		if !isConnected:
			isConnected = true
		if !connectSignalEmitted:
			on_ws_connected.emit()
			connectSignalEmitted = true
		timer.stop()
