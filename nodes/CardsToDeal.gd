extends Node2D

class_name CardsToDeal

func create_card_texture_rect(card_index: int) -> TextureRect:
	var image_index = card_index
	var textureRect: TextureRect = TextureRect.new()
	textureRect.texture = load(str("res://assets/cards/", image_index, ".png"))
	return textureRect

func deal_card(card_index: int, dest: Node2D, delay: float):
	var textureRect: TextureRect = create_card_texture_rect(card_index)
	
	var child: Sprite2D = get_child(0)
	remove_child(child)
	get_parent().add_child(child)
	child.position = position
	
	var tween: Tween = get_tree().create_tween()
	tween.set_loops(1)

	tween.finished.connect(_on_deal_to_deck_finished.bind(child, dest, textureRect))
	
	tween.parallel().tween_property(child, "position", dest.position, 0.3) \
		.set_trans(Tween.TRANS_QUAD).set_delay(delay)
	
	tween.parallel().tween_property(child, "rotation", 1, 0.15) \
		.set_trans(Tween.TRANS_CUBIC).set_delay(delay)

func deal_to_player(card_index: int, dest: Node2D, delay: float):
	var textureRect: TextureRect = create_card_texture_rect(card_index)
	
	var child: Sprite2D = get_child(0)
	remove_child(child)
	get_parent().add_child(child)
	child.position = position
	
	var tween: Tween = get_tree().create_tween()
	tween.set_loops(1)

	tween.finished.connect(_on_deal_once_finished.bind(child, dest, textureRect))
	
	tween.parallel().tween_property(child, "position", dest.position, 0.3) \
		.set_trans(Tween.TRANS_QUAD).set_delay(delay)
	
	tween.parallel().tween_property(child, "rotation", 1, 0.15) \
		.set_trans(Tween.TRANS_CUBIC).set_delay(delay)

func _on_deal_to_deck_finished(child: Sprite2D, dest: Node2D, textureRect: TextureRect):
	get_parent().remove_child(child)
	dest.get_node("CardList").add_child(textureRect)

func _on_deal_once_finished(child: Sprite2D, dest: Node2D, textureRect: TextureRect):
	get_parent().remove_child(child)
	dest.get_node("CardList").add_child(textureRect)


func deal_river_card(card_index: int, dest: Node2D, delay: float):
	deal_card(card_index, dest, delay)

func deal_turn_card(card_index: int, dest: Node2D, delay: float):
	deal_card(card_index, dest, delay)
	
func deal_flop_card(card_index: int, dest: Node2D, delay: float):
	deal_card(card_index, dest, delay)

func _ready():
	for times in range(0, 52):
		var cardSpirite = get_node("CardSetToDeal").duplicate()
		add_child(cardSpirite)
