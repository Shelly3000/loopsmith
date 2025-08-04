extends Node2D

var contents = [0,0,0,0,0,0,0,0]
var mold_type = 0
var component_temp = preload("res://component.tscn")
var necklace_temp = preload("res://necklace.tscn")

var bracelets = ["res://Assets/gold_bracelet.png","res://Assets/silver_bracelet.png","res://Assets/bronze_bracelet.png","res://Assets/bad_bracelet.png"]
var charms = ["res://Assets/gold_charm.png","res://Assets/silver_charm.png","res://Assets/bronze_charm.png","res://Assets/bad_charm.png"]
var necklaces = ["res://Assets/necklace_gold.png","res://Assets/necklace_silver.png","res://Assets/necklace_bronze.png","res://Assets/necklace_bronze.png"]
var rings = ["res://Assets/ring_gold.png","res://Assets/ring_silver.png","res://Assets/ring_bronze.png","res://Assets/ring_bad.png"]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body == self or body == $Area2D or body is StaticBody2D):
		return
	var type = body.type
	if (type == 0):
		
		contents[body.ingredient_num-1] += 1

		body.queue_free()
		
		

func _array_sum(array):
	var total = 0
	for num in array:
		total += num
	return total


func _mold_ingredients():
	var component = component_temp.instantiate()
	print(contents)
	#contents.reverse()
	print(contents.max())
	print(contents.find(contents.max))
	var material = contents.find(contents.max())
	print(material)
	if material >= 3:
		material = 3
	
	var total = _array_sum(contents)
	
	if (total == 2):
		component = component_temp.instantiate()
		self.get_parent().add_child(component)
		component.global_position = global_position + Vector2(250,-100)
		component.ingredient_num = material
		component.type = 1
		component.jewelery_type = 1
		var tex = load(rings[material]) as Texture2D  
		var image = tex.get_image()
		var texture = ImageTexture.create_from_image(image)
	
		component.texture = image
		component.get_child(0).texture = texture
		
		component.set_hitbox()
	
	elif (total == 3):
		component = component_temp.instantiate()
		self.get_parent().add_child(component)
		component.global_position = global_position + Vector2(250,-100)
		component.ingredient_num = material
		component.type = 1
		component.jewelery_type = 2
		var tex = load(charms[material]) as Texture2D  
		var image = tex.get_image()
		var texture = ImageTexture.create_from_image(image)
	
		component.texture = image
		component.get_child(0).texture = texture
		
		component.set_hitbox()
	elif (total == 4):
		component = component_temp.instantiate()
		self.get_parent().add_child(component)
		component.global_position = global_position + Vector2(300,-100)
		component.ingredient_num = material
		component.type = 1
		component.jewelery_type = 3
		var tex = load(bracelets[material]) as Texture2D  
		var image = tex.get_image()
		var texture = ImageTexture.create_from_image(image)
	
		component.texture = image
		component.get_child(0).texture = texture
		
		component.set_hitbox()
	elif (total >= 5):
		component = component_temp.instantiate()
		self.get_parent().add_child(component)
		component.global_position = global_position + Vector2(300,-100)
		component.ingredient_num = material
		component.type = 1
		component.jewelery_type = 4
		var tex = load(necklaces[material]) as Texture2D  
		var image = tex.get_image()
		var texture = ImageTexture.create_from_image(image)
	
		component.texture = image
		component.get_child(0).texture = texture
		
		component.set_hitbox()
	
	contents = [0,0,0,0,0,0,0,0]


func _on_button_pressed() -> void:
	$Sprite2D2.texture = load("res://Assets/mold_background.png")
	$Timer.wait_time = 2.0
	$Timer.start()
	$AudioStreamPlayer2D.play()


func _on_timer_timeout() -> void:
	$Sprite2D2.texture = load("res://Assets/mold_background_unlit.png")
	_mold_ingredients()
	$AudioStreamPlayer2D2.play()
