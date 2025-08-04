extends RigidBody2D

var ingredient_num = null
var jewelery_type = 0
var type = null
var texture = null
var in_adder = false
var collision_pos
var prev_velocity = Vector2(0,0)

var gems = []

var grabbed: bool = false
var previous_mouse_position: Vector2
var throw_velocity: Vector2
var towards: int = 0
var offset = 0

@onready var area = $CollisionShape2D

@export var grab_strength := 500.0
@export var max_force := 3000.0
@export var velocity_damping := 0.9

func _ready():
	
	input_pickable = true
	var contact_monitor = true
	var contacts_reported = 4
	randomize()


func get_centroid(points: PackedVector2Array) -> Vector2:
	var area := 0.0
	var cx := 0.0
	var cy := 0.0
	var n := points.size()
	
	for i in n:
		var p0 = points[i]
		var p1 = points[(i + 1) % n]
		var a = p0.x * p1.y - p1.x * p0.y
		area += a
		cx += (p0.x + p1.x) * a
		cy += (p0.y + p1.y) * a

	area *= 0.5
	if area == 0:
		return Vector2.ZERO
	return Vector2(cx / (6.0 * area), cy / (6.0 * area))

func set_hitbox():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture)

	var size = Vector2(texture.get_size())
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, size), 2.0)

	for poly in polys:
		# Compute the centroid of the polygon
		var centroid = get_centroid(poly)
		#collision_polygon.position -= centroid  # Center around actual mass center

		# Shift polygon points so that centroid is at origin
		var centered_poly = []
		for point in poly:
			centered_poly.append(point - centroid)

		# Create and position the collision polygon
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = centered_poly
		collision_polygon.position = centroid - size / 2.0  # Center in Sprite
		collision_pos = centroid - size / 2.0
		self.add_child(collision_polygon)
	#var texture = $Sprite2D.texture
	print("set hitbox")
	#var bitmap = BitMap.new()
	#bitmap.create_from_image_alpha(texture)

	#var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size()))
	#for poly in polys:
	#	var collision_polygon = CollisionPolygon2D.new()
	#	collision_polygon.polygon = poly
	#	self.add_child(collision_polygon)
#
		# Generated polygon will not take into account the half-width and half-height offset
		# of the image when "centered" is on. So move it backwards by this amount so it lines up.
		
	#	collision_polygon.position -= Vector2(bitmap.get_size()) / 2.0



func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			grabbed = true
			lock_rotation = true
			previous_mouse_position = get_global_mouse_position()
			offset = global_position - previous_mouse_position
			self.gravity_scale = 0
		

func _physics_process(delta):
	if grabbed:
		var max_speed := 5000
		var target = get_global_mouse_position() + offset
		var direction = target - global_position
		direction = direction.normalized()
		var slowdown_distance := 200.0
		var force
		var distance = global_position.distance_to(target)
		var speed_factor = clamp(distance / slowdown_distance, 0, 1)
		
		
		
		
		
		
		if distance > 1.0:
		# Normalize direction
			

		# Calculate speed factor (0 to 1) based on distance
			

		# Set velocity (use linear_velocity for RigidBody2D)
			linear_velocity = direction * max_speed * speed_factor
		else:
		# Stop completely when close enough
			linear_velocity = Vector2.ZERO

		
		#if (sqrt(global_position.distance_to(target)) < 12):
		#	force = direction * (sqrt(global_position.distance_to(target)))
		#elif (sqrt(global_position.distance_to(target)) < 17) and (towards > 0):
		#	force = -direction * sqrt(global_position.distance_to(target)/3)
		#	towards -= 1
		#elif (sqrt(global_position.distance_to(target)) < 17):
		#	force = direction * sqrt(global_position.distance_to(target)/2)
		#	
		#else:
		#	force = direction * global_position.distance_to(target)
		#	towards = 4
		
		#print(sqrt(global_position.distance_to(target)))
		

		#apply_force(force)

		throw_velocity = (target - previous_mouse_position) / delta
		previous_mouse_position = get_global_mouse_position()
	#elif (in_adder and type == 1 and global_rotation != 0):
		
		#self.global_rotation = 0
	#if (linear_velocity.length() < 10 and prev_velocity.length() > 10 and !grabbed):
	#	play_sound()
	#prev_velocity = linear_velocity
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and grabbed:
			grabbed = false
			lock_rotation = false
			if !(in_adder):
				gravity_scale = 1
			

func _play_random_pitch_sfx():
	var sfx_player = $AudioStreamPlayer2D
	sfx_player.pitch_scale = randf_range(0.7, 1.4)  # Small variation
	sfx_player.play()



var sounds = [preload("res://Assets/sound/Sonic_Soundfx_household_kitchen_glass_worktop_surface_counter_1.mp3"),preload("res://Assets/sound/Sonic_Soundfx_household_living_room_lounge_glass_small_wood_table_1.mp3"),preload("res://Assets/sound/zapsplat_foley_gems_bag_precious_stones_small_set_down_carpet_005_67794.mp3")]

func play_sound():
	var impact = prev_velocity.length()
	print("ji")
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.95, 1.05)
	var normalized_speed = clamp(impact / 30.0, 0, 1)
			
			# Use quadratic curve for volume (quieter at low speed)
	var volume_db = lerp(-40, -5, normalized_speed * normalized_speed)
	$AudioStreamPlayer2D.volume_db = volume_db
	$AudioStreamPlayer2D.stream = sounds[randi() % sounds.size()]
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play() # Replace with function body.
