extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var joinBtn: Button = get_child(1)
	joinBtn.pressed.connect(_on_join_table)
	

func _on_join_table():
	var animation: AnimationPlayer = get_node("AnimationPlayer")
	animation.play("hide_front_door")
	
	var table_scene = load("res://nodes/TableControl.tscn")
	get_parent().add_child(table_scene.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
