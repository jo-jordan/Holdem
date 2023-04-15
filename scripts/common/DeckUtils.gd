extends Node

class_name DeckUtils

var card_list: Array

func _init():
	for i in GameConstants.CARD_INDEX_LIST:
		card_list.push_back(i)
	card_list.shuffle()
	
func deal():
	return card_list.pop_back()

func reinit():
	card_list = Array(GameConstants.CARD_INDEX_LIST)
	card_list.shuffle()
	

