# growth - Lindenmayer Systems implemented in Godot
# Copyright (C) 2021  Christoph Czurda <rdssdf.fd@gmx.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

class_name StochasticProductionPicker
extends ProductionPicker

var rng: RandomNumberGenerator

func _init(_rng: RandomNumberGenerator):
	rng = _rng

# Returns an index into the array. The probability for each index is based
# on the probability factor of the element.
func pick(applicable_productions: Array) -> int:
	if applicable_productions.size() == 1:
		return 0
	var sum = _sum(applicable_productions)
	if sum == 0.0:
		return 0
	var probabilities = _weighted(applicable_productions, sum)
	probabilities.sort_custom(self, "sort_ascending")
	return _get_random_weighted_index(probabilities)

static func _sum(applicable_productions: Array) -> float:
	var sum = 0.0
	for p in applicable_productions:
		sum += p.probability_factor
	return sum

static func _sort_ascending(a, b) -> bool:
	return a[1] <= b[1]

static func _weighted(applicable_productions, sum):
	var probabilities = []
	for i in range(applicable_productions.size()):
		var factor = applicable_productions[i].probability_factor
		if factor >= 0.0:
			probabilities.append([i, factor/sum])
	return probabilities

func _get_random_weighted_index(probabilities):
	var accumulated_probability = 0.0
	var random = rng.randf()
	for p in probabilities:
		accumulated_probability += p[1]
		if random <= accumulated_probability:
			return p[0]
	return 0
