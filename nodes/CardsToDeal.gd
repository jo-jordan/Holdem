extends Node2D

class_name CardsToDeal

func deal_to_player(seat: int, card_index: int, dest: Node2D, delay: float):
	var image_index = GameConstants.CARD_INDEX_TO_IMAGE_INDEX[card_index]
	var textureRect: TextureRect = TextureRect.new()
	textureRect.texture = load("res://assets/cards/"+ str(image_index)+ ".png")
	
	var tween = get_tree().create_tween()
	tween.set_loops(1)
	var child = get_child(0)
	remove_child(child)
	get_parent().add_child(child)
	child.position = position
	tween.finished.connect(_on_deal_once_finished.bind(child, dest, textureRect))
	
	tween.parallel().tween_property(child, "position", dest.position, 0.3) \
		.set_trans(Tween.TRANS_QUAD).set_delay(delay)
	
	tween.parallel().tween_property(child, "rotation", 6, 0.15) \
		.set_trans(Tween.TRANS_CUBIC).set_delay(delay)
	

func _on_deal_once_finished(child: Sprite2D, dest: Node2D, textureRect: TextureRect):
	get_parent().remove_child(child)
	dest.get_node("CardList").add_child(textureRect)

func deal_river_card():
	pass

func deal_turn_card():
	pass
	
func deal_flip_card():
	pass

func _ready():
	for times in range(0, 12):
		var cardSpirite = get_node("CardSetToDeal").duplicate()
		add_child(cardSpirite)
