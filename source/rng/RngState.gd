class_name RngState

var rng: RandomNumberGenerator
var random_seed: int
var rng_state: int

func initialize(random_seed: int):
	rng.set_seed(random_seed)
	rng_state = rng.get_state()

func reset():
	rng.set_state(rng_state)
