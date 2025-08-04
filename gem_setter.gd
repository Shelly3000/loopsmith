extends RigidBody2D

var grabbed := false
var home_pos = null
var offset = Vector2.ZERO

var bodies = []

func _ready() -> void:
	home_pos = global_position
	
	
func _physics_process(delta: float) -> void:
	if grabbed:
		global_position = get_global_mouse_position() + offset
	else:
		var max_speed := 2000
		var target = home_pos
		var direction = target - global_position
		direction = direction.normalized()
		var slowdown_distance := 200.0
		var force
		var distance = global_position.distance_to(target)
		var speed_factor = clamp(distance / slowdown_distance, 0, 1)
		
		if distance > 1.0:

			linear_velocity = direction * max_speed * speed_factor
		else:
		# Stop completely when close enough
			linear_velocity = Vector2.ZERO

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			grabbed = true
			offset = global_position - get_global_mouse_position()
			print("eee")
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and grabbed:
			grabbed = false
			_bind_objects()
			
			
func _bind_objects():
	bodies = $Area2D.get_overlapping_bodies()
	print(bodies)
	
	var mainbody
	var detected = false
	if (len(bodies) >= 2):
		for body in bodies:
			if (body.type==1 and detected == false):
				mainbody = body
				detected = true
				bodies.erase(mainbody)
			
		if detected:
			for body in bodies:
				
				
				var global_B = body.global_transform
				var collider = body.get_child(2)
				var global_c = collider.global_transform
				body.get_parent().remove_child(body)
				mainbody.add_child(body)
				body.transform = mainbody.global_transform.affine_inverse() * global_B

				body.remove_child(collider)
				mainbody.add_child(collider)
				body.z_index = 1
				
				collider.transform = mainbody.global_transform.affine_inverse() * global_c
				
				#body.collision_layer = 7
				#body.collision_mask = 7
				body.freeze = true
				
				mainbody.gems.append(body.gems)
				
				
			
		
	
	
	bodies = []
	
