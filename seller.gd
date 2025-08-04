extends StaticBody2D

var customer_type
var customer_base
var customer_gems
var item_type
var item_base
var item_gems
@onready var area = $Area2D
@onready var customer = self.get_parent().get_node("Customer")
@onready var money = self.get_parent().get_parent().get_node("Camera2D").get_child(0).get_child(2)

var totalmoney = 0


func _on_button_pressed() -> void:
	if !(customer.is_buying):
		return
	var bodies = area.get_overlapping_bodies()
	var found = false
	
	var mainbody
	for body in bodies:
		if body.type == 1:
			found = true
			mainbody = body
			break
	if !found:
		return
	item_type = mainbody.jewelery_type
	item_base = mainbody.ingredient_num
	item_gems = mainbody.gems
	customer_base = customer.base_id
	customer_gems = customer.gem_id
	customer_type = customer.requested_type_id
	
	var percent = 0.0
	
	if item_type == customer_type:
		percent += .4
	if item_base == customer_base:
		percent +=.3
	print(customer_gems)
	print(item_gems)
	for item in customer_gems:
		if item in item_gems:
			percent += .1
			
	var moneye = round((randi() % 51 + 50)*percent)
	totalmoney += moneye
	print(percent)
	
	
	money.text = str(totalmoney)
	customer.start_interaction()
	customer.get_child(2).queue_free()
	mainbody.queue_free()
