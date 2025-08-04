extends Node2D
var ingredient_temp = preload("res://ingredient.tscn")
var egypt_sprites = ["res://Assets/gold.png","res://Assets/silver.png","res://Assets/bronze.png","res://Assets/lapis.png","res://Assets/carnelian.png","res://Assets/turquoise.png","res://Assets/glass.png","res://Assets/amethyst.png"]
var era = 0

var gems = ["gold","silver","bronze","lapis","carnelian","turquoise","glass","amethyst"]


func _ready() -> void:
	var s1 = $shelf1
	var s2 = $shelf2
	var s3 = $shelf3
	var s4 = $shelf4
	var s5 = $shelf5
	var s6 = $shelf6
	var s7 = $shelf7
	var s8 = $shelf8
	
	
	s1.connect("input_event",_on_shelf_1_input_event)
	s2.connect("input_event",_on_shelf_2_input_event)
	s3.connect("input_event",_on_shelf_3_input_event)
	s4.connect("input_event",_on_shelf_4_input_event)
	s5.connect("input_event",_on_shelf_5_input_event)
	s6.connect("input_event",_on_shelf_6_input_event)
	s7.connect("input_event",_on_shelf_7_input_event)
	s8.connect("input_event",_on_shelf_8_input_event)


func spawn_ingredient(num):
	print("SPAWNING " + str(num))
	var item = ingredient_temp.instantiate()
	self.get_parent().add_child(item)
	item.global_position = get_global_mouse_position()
	item.ingredient_num = num
	item.type = 0
	var tex = load(egypt_sprites[num-1]) as Texture2D  
	var image = tex.get_image()
	var texture = ImageTexture.create_from_image(image)
	
	item.texture = image
	item.get_child(0).texture = texture
		
	item.gems = float(num-1)
		
	item.set_hitbox()
	_play_random_pitch_sfx()

func _play_random_pitch_sfx():
	var sfx_player = $AudioStreamPlayer2D
	sfx_player.pitch_scale = randf_range(0.95, 1.05)  # Small variation
	sfx_player.play()



func _on_shelf_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient(1)

func _on_shelf_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient(2)

func _on_shelf_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient(3)

func _on_shelf_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient(4)

func _on_shelf_5_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient(5)

func _on_shelf_6_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient(6)

func _on_shelf_7_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient(7)

func _on_shelf_8_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient(8)
