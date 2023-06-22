extends Node

var username = ""
var playerId = ""
var roomId = ""
var roomName = ""
var playerList = []
var gameConfig

var env = "l"
# prod "wss://holdem-game.edgeless.me"
# local "ws://192.168.3.2:8888"
var ws_url = "wss://holdem-game.edgeless.me" if env == "prod" else "ws://192.168.3.2:8888"

# prod "https://holdem-auth.edgeless.me/login"
# local "http://192.168.3.2:8887/login"
var http_url = "https://holdem-auth.edgeless.me/login" if env == "prod" else "http://192.168.3.2:8887/login"
