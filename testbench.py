from pyverilator import PyVerilator

sim = PyVerilator.build('machine01.v')

def tick():
    sim.io.CLK = 1
    sim.io.CLK = 0

def reset():
    sim.io.RST_N = 0
    tick()
    sim.io.RST_N = 1
    tick()
    
def step(c):
    assert(sim.io.RDY_put == 1)
    sim.io.put_c = c
    sim.io.EN_put = 1
    tick()
    sim.io.EN_put = 0
    tick()
    if (sim.io.RDY_observe == 1):
        return sim.io.observe.value
    else:
        return None

def test(cs):
    reset()
    return [step(c) for c in cs]

assert(test([0, 1]) == [None, 1])
assert(test([0, 1, 0]) == [None, 1, 0])
assert(test([0, 1, 1]) == [None, 1, 0])
assert(test([0, 0]) == [None, 0])
assert(test([1, 0, 0]) == [0, 0, 0])
