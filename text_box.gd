extends MarginContainer
@onready var label = $MarginContainer/RichTextLabel

var text_tween = null

func change_text(text):
	label.text = text
	label.visible_ratio = 0
	text_tween = create_tween()
	text_tween.tween_property(
		label, "visible_ratio", 1, (text.length()*.01)
	).set_trans(Tween.TRANS_LINEAR)
