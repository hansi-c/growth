class_name WordBuilder

func apply_production(word: String, index: int, successor: String) -> String:
	if successor == null:
		return word
	var result = ""
	result = word.substr(0, index) + successor
	if word.length() > index:
		result += word.substr(index+1)
	return result
