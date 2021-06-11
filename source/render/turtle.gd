class_name Turtle

var start: Vector2
var start_angle: float
var turn_degrees: float
var segment_length: float
var lines = []
var leaves = []
var fruits = []
var state = TurtleState.new()

func generate_lines(word, current_iteration: int):
	lines.clear()
	leaves.clear()
	fruits.clear()
	state.set_position(start)
	state.set_angle(start_angle)
	state.set_width(current_iteration * 0.66)

	for i in range(word.length()):
		var s = word[i]
		if s == "F":
			var direction = Vector2(cos(state.angle), sin(state.angle))
			var line_segment = line_segment(state.position, direction, state.width)
			lines.append(line_segment)
			state.position = line_segment.end
		elif s == "-":
			state.turn_clockwise(turn_degrees)
		elif s == "+":
			state.turn_counter_clockwise(turn_degrees)
		elif s == "[":
			state.push_state()
			state.width *= 0.66
		elif s == "]":
			state.pop_state()
		elif s == "A":
			leaves.append(state.position + Vector2(0,2.0))
		elif s == "B":
			fruits.append(state.position + Vector2(0,2.0))

func line_segment(_start, direction, width):
	var result = LineSegment.new()
	result.start = _start
	result.end = _start + (direction * segment_length)
	result.width = width
	return result
