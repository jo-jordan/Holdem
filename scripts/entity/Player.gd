extends Node

class_name Player

var seat: int
var username: String
var is_self: bool
var no: int
var chips: int

func _init(seat: int, username: String, no: int, is_self: bool = false):
	self.username = username
	self.seat = seat
	self.is_self = is_self
	self.no = no
