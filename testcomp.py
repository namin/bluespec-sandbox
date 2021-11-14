from pyverilator import PyVerilator

verilog_path = ['.', '../bsc/src/Verilog/']

sim = PyVerilator.build('mkTransNoStutter.v', verilog_path=verilog_path)

def tick():
    sim.io.CLK = 1
    sim.io.CLK = 0

def reset():
    sim.io.RST_N = 0
    tick()
    sim.io.RST_N = 1
    tick()

def send(c):
    assert(sim.io.RDY_send == 1)
    sim.io.send_c = c
    sim.io.EN_send = 1
    tick()
    sim.io.EN_send = 0
    tick()

def receive():
    assert(sim.io.RDY_receive == 1)
    sim.io.EN_receive = 1
    tick()
    sim.io.EN_receive = 0
    tick()
    return sim.io.receive.value

reset()
send(1)
send(1)
send(1)
assert(receive() == 1)
assert(sim.io.RDY_receive == 0)
send(0)
send(0)
send(1)
assert(sim.io.RDY_receive == 0)
send(0)
send(1)
send(0)
send(0)
assert(sim.io.RDY_receive == 0)
send(0)
assert(receive() == 0)

sim = PyVerilator.build('mkComp.v', verilog_path=verilog_path)

reset()
send(1)
send(1)
send(1)
assert(sim.io.RDY_receive == 0)
send(1)
send(1)
send(1)
assert(sim.io.RDY_receive == 0)
send(1)
send(1)
send(1)
send(0) # TODO: why need extra?
assert(receive() == 1)
assert(sim.io.RDY_receive == 0)
send(0)
send(1)
send(1)
assert(sim.io.RDY_receive == 0)
send(0)
send(1)
send(0)
send(0)
assert(sim.io.RDY_receive == 0)
send(0)
send(0)
send(0)
send(0)
send(0)
send(0)
assert(sim.io.RDY_receive == 0)
send(0)
send(1) # TODO: why need extra?
assert(receive() == 0)
