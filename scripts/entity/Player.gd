extends Node

class_name Player

var seat: int
var username: String
var is_self: bool
var no: int
var chips: int

func _init(s: int, u: String, n: int, i_s: bool = false):
	self.username = u
	self.seat = s
	self.is_self = i_s
	self.no = n
