extends Node2D

var price = 0
var text = ""

var sprites = [load("res://Assets/people/man1-export.png"),load("res://Assets/people/man2-export.png"),load("res://Assets/people/man3-export.png"),load("res://Assets/people/woman1-export.png"),load("res://Assets/people/woman2-export.png"),load("res://Assets/people/woman3-export.png"),load("res://Assets/people/woman4-export.png"),load("res://Assets/people/woman5-export.png"),load("res://Assets/people/woman6-export.png")]

var tb_instance = null
var text_box = preload("res://text_box.tscn")

var interaction = 0
var era = "egypt"
var prompt_parts = {}

var requested_type_id: int = -1
var requested_type_text: String = ""
var base_id: int = -1
var gem_id = []

var is_buying = false

var _original_y: float
var _bobbing_timer: float = 0.0
var _is_bobbing: bool = false

func _ready() -> void:
	load_prompt_parts()
	start_interaction()

func interact():
	if interaction == 0:
		tb_instance = text_box.instantiate()
		add_child(tb_instance)
		tb_instance.position = Vector2i(223, -345)
		tb_instance.size = Vector2i(836, 304)
		var question = generate_question()
		tb_instance.change_text(question)
		print(base_id)
		print(gem_id)
		is_buying = true
	elif interaction == 1:
		print("yay")
		interaction -= 1
	interaction += 1

func load_prompt_parts() -> void:
	var file := FileAccess.open("res://prompt_parts.json", FileAccess.READ)
	if file:
		var json_string: String = file.get_as_text()
		var parse_result: Variant = JSON.parse_string(json_string)
		if typeof(parse_result) == TYPE_DICTIONARY:
			prompt_parts = parse_result as Dictionary
		else:
			push_error("Failed to parse JSON: Invalid structure or syntax.")
	else:
		push_error("Failed to open prompt_parts.json")

func generate_question() -> String:
	if not prompt_parts.has(era):
		return "No prompt data found for era: %s" % era

	var era_parts: Dictionary = prompt_parts[era]
	var question: Array[String] = []

	# Greeting
	if randi() % 100 < 70:
		var opener := random_part_text(era_parts, "openers")
		if opener != "":
			question.append(opener.capitalize())

	# Reason
	var reason_obj: Dictionary = random_part_object(era_parts, "reason")

	# Type
	var type_data := random_part_object(era_parts, "type")
	requested_type_id = type_data["id"]
	requested_type_text = type_data["text"].strip_edges().to_lower()

	# Specifics
	var base_spec_data := random_part_object(era_parts, "base_specifics")
	var gem_specs := get_random_gem_specifics_data(era_parts)
	var gem_texts: Array[String] = []
	var gem_ids = []
	for gem in gem_specs:
		gem_texts.append(gem["text"].strip_edges())
		gem_ids.append(gem["id"])
	print(gem_specs)
	print(gem_texts)
	
	base_id = base_spec_data["id"]
	gem_id = gem_ids

	var specifics_joined := format_gem_phrase(gem_texts)

	# Transition
	var transition_text := random_part_text(era_parts, "transitions")
	var article := get_indefinite_article(requested_type_text)
	var base_text: String = base_spec_data["text"].strip_edges()
	var combined_phrase: String

	if specifics_joined != "":
	# Both base and gem specifics
		combined_phrase = "%s with %s" % [base_text, specifics_joined]
	else:
	# Only base specific
		combined_phrase = base_text

	var pottery_phrase := "%s %s, %s" % [article, requested_type_text, combined_phrase]


	# Order
	var first_part: String
	var second_part: String
	if randi() % 2 == 0:
		first_part = reason_obj["start"].capitalize()
		if not first_part.ends_with("."):
			first_part += "."
		second_part = "%s %s?" % [transition_text, pottery_phrase]
	else:
		first_part = "%s %s." % [transition_text, pottery_phrase.capitalize()]
		second_part = reason_obj["end"]
		if not second_part.ends_with("."):
			second_part += "."

	question.append(first_part)
	question.append(second_part)

	return " ".join(question)

func get_random_gem_specifics_data(era_parts: Dictionary) -> Array:
	var all_gems: Array = era_parts.get("gem_specifics", [])
	var shuffled := all_gems.duplicate()
	shuffled.shuffle()
	var count := get_gem_specific_count()
	return shuffled.slice(0, count)

func get_gem_specific_count() -> int:
	var roll := randi() % 100
	if roll < 50:
		return 1
	elif roll < 85:
		return 2
	else:
		return 3

func format_gem_phrase(gems: Array[String]) -> String:
	if gems.size() == 0:
		return ""
	var intro_phrases = ["inlaid with", "decorated with", "adorned with", "set with", "featuring"]
	var intro = intro_phrases[randi() % intro_phrases.size()]
	if gems.size() == 1:
		return "%s %s" % [intro, gems[0]]
	elif gems.size() == 2:
		return "%s %s and %s" % [intro, gems[0], gems[1]]
	else:
		var all_but_last := gems.slice(0, gems.size() - 1)
		var last := gems[gems.size() - 1]
		return "%s %s, and %s" % [intro, ", ".join(all_but_last), last]

func get_indefinite_article(word: String) -> String:
	var first_char := word.strip_edges().substr(0, 1).to_lower()
	return "an" if ["a", "e", "i", "o", "u"].has(first_char) else "a"

func random_part_text(era_data: Dictionary, key: String) -> String:
	var list: Array = era_data.get(key, [])
	return list[randi() % list.size()] if list.size() > 0 else ""

func random_part_object(era_data: Dictionary, key: String) -> Dictionary:
	var list: Array = era_data.get(key, [])
	return list[randi() % list.size()] if list.size() > 0 else {}





func start_interaction():
	interaction = 0
	global_position = Vector2(-200,700)
	$Sprite2D.texture = sprites[randi() % sprites.size()]
	show()
	play_bobbing_movement()



@export var move_distance: float = 749.0
@export var move_duration: float = 10.0
@export var bobbing_amplitude: float = 10.0
@export var bobbing_frequency: float = 4.0


var _is_playing := false
	
func play_bobbing_movement():
	

	# Reset original Y
	_original_y = 700

	# Animate X position
	var tween := create_tween()
	tween.tween_property(self, "position:x", 579, 2.0).set_trans(Tween.TRANS_SINE)

	# Tween callback to stop bobbing
	tween.tween_callback(Callable(self, "_on_tween_complete"))

	# Start bobbing
	_bobbing_timer = 0.0
	_is_bobbing = true

func _process(delta):
	if _is_bobbing:
		_bobbing_timer += delta
		var offset_y := sin(_bobbing_timer * TAU * bobbing_frequency) * bobbing_amplitude
		position.y = _original_y + offset_y


func _on_tween_complete():
	_is_bobbing = false
	position.y = _original_y
