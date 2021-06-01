class_name D0LineGenerator

var start: Vector2
var start_angle: float
var turn_degrees: float
var segment_length: float
var lines = []
var circles = []
var fruits = []
var state = PlantState.new()

func generate_lines(word, current_iteration: int):
	lines.clear()
	circles.clear()
	fruits.clear()
	state.set_position(start)
	state.set_angle(start_angle)
	state.set_width(current_iteration * 0.66)

	for s in word:
		if s == "F":
			var direction = Vector2(cos(state.angle), sin(state.angle))
			var branch = generate_branch(state.position, direction, state.width)
			lines.append(branch)
			state.position = branch.end
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
			# FIXME this belongs into the grammar of course. So we need a non-deterministic grammar
#			if randf() > 0.9:
			circles.append(state.position + Vector2(0,2.0))
		elif s == "B":
			# FIXME this belongs into the grammar of course. So we need a non-deterministic grammar
			if randf() < 0.1:
				fruits.append(state.position + Vector2(0,2.0))

func generate_branch(_start, direction, width):
	var result = LineSegment.new()
	result.start = _start
	result.end = _start + (direction * segment_length)
	result.width = width
	return result
