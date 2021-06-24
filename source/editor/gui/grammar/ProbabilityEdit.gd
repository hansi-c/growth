extends ProductionEdit
class_name ProbabilityEdit

var regex: RegEx

func _ready():
	regex = RegEx.new()
	regex.compile("(\\.\\d+)|(\\d+\\.?\\d*)")

func _on_text_changed(text: String):
	var matched = regex.search(text)
	var value = 0.0
	if matched:
		value = text.to_float()
	production.probability_factor = value
	set_text(str(production.probability_factor))
