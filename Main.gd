extends Node

# The URL we will connect to

var http_auth_url = Global.http_url


var isLogin = false
var json = JSON.new()

var timer = Timer.new()
var isJoinRoom = false

var roomList = []

func _ready():
	NetworkHub.room_created.connect(_room_created)
	NetworkHub.room_joined.connect(_room_joined)
	NetworkHub.room_searched.connect(_room_searched)
	if !isLogin:
		$LoginDialog.visible = true
	
func _login():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_login_completed)
	
	var headers = PackedStringArray(
		[str("X-Username:", Global.username), str("X-Password:", "aa")])

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request(http_auth_url, headers)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		
	await http_request.request_completed

# Called when the HTTP request is completed.
func _http_login_completed(_result, _response_code, _headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	Global.playerId = response["playerId"]
	isLogin = true
	
	NetworkHub.connect_to_ws()
	await NetworkHub.on_ws_connected
	$LoginDialog.visible = false
	
func _check_and_set_username():
	Global.username = $LoginDialog/UsernameText.text
	if Global.username == null || Global.username == "":
		$Popup.visible = true
		$Popup/Label.text = "Enter your username first!"
		return
		

func _search_room(keyword):
	var dict = {
		"type": "ROOM_SEARCH",
		"keyword": keyword
	}
	NetworkHub.send(dict)

func _room_joined(data):
	var roomInfo = data["roomInfo"]
	Global.playerList = roomInfo["playerInfoList"]
	Global.roomName = roomInfo["roomName"]
	Global.gameConfig = roomInfo["gameConfig"]
	Global.roomId = roomInfo["roomId"]
	print("_room_joined: ", data)
	

	var room_scene = load("res://nodes/Room.tscn")
	var room: Room = room_scene.instantiate()
	room.update_players()
	get_parent().add_child(room)
	
	queue_free()

func _room_created(data):
	var roomInfo = data["roomInfo"]
	Global.playerList = roomInfo["playerInfoList"]
	Global.roomName = roomInfo["roomName"]
	Global.gameConfig = roomInfo["gameConfig"]
	Global.roomId = roomInfo["roomId"]
	print("_room_created: ", data)
	

	var room_scene = load("res://nodes/Room.tscn")
	var room: Room = room_scene.instantiate()
	room.update_players()
	get_parent().add_child(room)
	
	queue_free()

func _room_searched(data):
	roomList = data["roomList"]
	$AcceptDialog/ItemList.clear()
	if !$AcceptDialog/ItemList.item_clicked.is_connected(_do_join_room):
		$AcceptDialog/ItemList.item_clicked.connect(_do_join_room)
	for room in data["roomList"]:
		$AcceptDialog/ItemList.add_item(str(room.roomName, ": ", room.roomId))
		

func _do_join_room(index, _p1, _p2):
	Global.roomId = roomList[index]["roomId"]
	var dict = {
		"type": "ROOM_JOIN",
		"playerId": Global.playerId,
		"roomId": Global.roomId
	}
	NetworkHub.send(dict)
	$AcceptDialog.visible = false

func _join_room():
	if !$WSTimer.is_stopped():
		$WSTimer.stop()
		
	_search_room("")
	


func _create_room():
	$WSTimer.stop()
	print("_create_room", Global.playerId)
	var dict = {
		"type": "ROOM_CREATE",
		"playerId": Global.playerId,
		"name": "Holdem"
	}
	NetworkHub.send(dict)

func _on_join_table_pressed():
	isJoinRoom = true
	_check_and_set_username()
	if !isLogin:
		return
	$AcceptDialog.visible = true
	_join_room()

func _on_create_table_pressed():
	isJoinRoom = false
	_check_and_set_username()
	
	if !isLogin:
		return
	_create_room()



func _on_login_dialog_confirmed():
	$LoginDialog.get_ok_button().visible = false
	$LoginDialog.visible = true
	Global.username = $LoginDialog/UsernameText.text
	_login()

