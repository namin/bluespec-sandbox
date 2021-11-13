interface MachineIfc;
   method Action put(Bit#(1) c);
   method Bool observe();
endinterface

(* synthesize *)
module machine01(MachineIfc);
   Reg#(Bit#(2)) state <- mkReg(0);
   Reg#(Maybe#(Bit#(1))) signal <- mkReg(tagged Invalid);

   rule state0 (state == 0 && signal != Invalid);
      state <= (signal == Valid(0)) ? 1 : 3;
      signal <= Invalid;
   endrule

   rule state1 (state == 1 && signal != Invalid);
      state <= (signal == Valid(1)) ? 2 : 3;
      signal <= Invalid;
   endrule

   rule state2 (state == 2 && signal != Invalid);
      state <= 3;
      signal <= Invalid;
   endrule

   rule state3 (state == 3 && signal != Invalid);
      signal <= Invalid;
   endrule

   method Action put(Bit#(1) c) if (signal == Invalid);
      signal <= Valid(c);
   endmethod

   method Bool observe() if (state == 2 || state == 3);
      if (state == 2) return True;
      else /*(state == 3)*/ return False;
   endmethod
endmodule
