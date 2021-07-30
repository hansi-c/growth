class_name ControlSymbols

var _rotate_cw: String = "-"
var _rotate_ccw: String = "+"
var _branching_symbols: BranchingSymbols = BranchingSymbols.new()

func get_rotate_cw() -> String:
	return _rotate_cw

func set_rotate_cw(symbol: String):
	_rotate_cw = symbol

func get_rotate_ccw() -> String:
	return _rotate_ccw

func set_rotate_ccw(symbol: String):
	_rotate_ccw = symbol

func get_branching_symbols() -> BranchingSymbols:
	return _branching_symbols

func set_branching_symbols(symbols: BranchingSymbols):
	_branching_symbols = symbols

func get_open_branch() -> String:
	return _branching_symbols.open_branch

func set_open_branch(symbol: String):
	_branching_symbols.open_branch = symbol

func get_close_branch() -> String:
	return _branching_symbols.close_branch

func set_close_branch(symbol: String):
	_branching_symbols.close_branch = symbol

func enumerate() -> Array:
	return enumerate_dictionary().keys()
	
func enumerate_dictionary() -> Dictionary:
	return {
		_rotate_cw: true,
		_rotate_ccw: true,
		_branching_symbols.open_branch: true,
		_branching_symbols.close_branch: true
	}
