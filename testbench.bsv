import machine01::*;

import BuildVector::*;
import Vector::*;

module testbench();
   MachineIfc machine <- machine01();
   Vector#(3, Bit#(1)) tests = vec(0,1,0);

   Reg#(Bit#(5)) it <- mkReg(0);
   Reg#(Bit#(5)) obs <- mkReg(0);

   rule interactWithMachine if (it < 3);
      $display("Input: ", tests[it]);
      machine.put(tests[it]);
      it <= it + 1;
   endrule

   rule observeMachine if (obs < 15);
      $display("Observed: ", fshow(machine.observe()));
      if (obs == 14) $finish();
      obs <= obs + 1;
   endrule

endmodule
