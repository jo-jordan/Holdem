extends Node

class_name Player

var seat: int
var nick: String
var is_self: bool
var no: int

func _init(seat: int, nick: String, no: int, is_self: bool = false):
	self.nick = nick
	self.seat = seat
	self.is_self = is_self
	self.no = no
