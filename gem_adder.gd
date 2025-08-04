extends Node2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	body.in_adder = true
	body.gravity_scale = 0
	if (body.type == 1):
		
		body.collision_layer = 2
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(2, true)
		
		
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.in_adder = false
	body.gravity_scale = 1
	if (body.type == 1):
		body.collision_layer = 1
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(2, false)
		
