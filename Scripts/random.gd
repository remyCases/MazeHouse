class_name RandomUtils
extends RefCounted

static var rng := RandomNumberGenerator.new()

static func set_seed(new_seed: int):
	rng.set_seed(new_seed)

static func rand_int(max_value: int) -> int:
	return rng.randi_range(0, max_value - 1)

# from Knuth Donald, The Art Of Computer Programming, Volume 2, Third Edition
# 3.4.2 Random Sampling and Shuffling, p145
# Algorithm P
# Known as the Fisher-Yates-Durstenfeld-Knuth algorithm
static func fydk_shuffling(list: Array):
	var tt: int = list.size()
	var j: int = tt - 1
	var k: int = 0
	var temp

	while j > 0:
		k = rand_int(tt)
		temp = list[k]
		list[k] = list[j]
		list[j] = temp
		j -= 1


static func selection_sampling(list: Array, n: int) -> Array:
	# number of elements dealt with
	var tt: int = 0
	# number of elements selected by the algorithm
	var m: int = 0
	var N: int = list.size()
	# firewall if we want more elements than the size of the list
	var nn: int = min(n, N)
	var u: float
	var result: Array = []
	while m < nn:
		u = rng.randf()
		if((N - tt)*u >= nn - m):
			# element not selected
			tt += 1
		else:
			# element selected
			result.append(list[tt])
			tt += 1
			m += 1

	return result

static func poisson_sampling(mu: float) -> int:
	var L: float = exp(-mu)
	var k: int = 0
	var p: float = 1.0
	var u: float
	
	k = k + 1
	u = rng.randf()
	p = u*p
	while (p >= L):
		k = k + 1
		u = rng.randf()
		p = u*p
	return k - 1
