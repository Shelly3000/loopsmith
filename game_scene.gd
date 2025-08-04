extends Node2D

@onready var cam = $Camera2D
@onready var shop_pos = $Shopfront.global_position
@onready var work_pos = $Workfront.global_position
@onready var customer = $Shopfront/Customer

var in_shop = true
var cam_tween = null

func _ready():
	cam.position = shop_pos
	

func switch_area():
	in_shop = !in_shop
	var target_pos = shop_pos if in_shop else work_pos
	if cam_tween and cam_tween.is_valid():
		cam_tween.kill()
	cam_tween = create_tween()
	cam_tween.tween_property(
		cam, "position", target_pos, 0.8
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_switch_button_pressed() -> void:
	switch_area() # Replace with function body.



func _on_customer_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			customer.interact()


func _on_area_2d_mouse_entered() -> void:
	switch_area() # Replace with function body.
