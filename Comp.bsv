package Comp;

import FIFO::*;

interface Trans_ifc;
   method Action send(Bit#(1) c);
   method ActionValue#(Bit#(1)) receive;
endinterface

(* synthesize *)
module mkComp (Trans_ifc);
   Trans_ifc t1 <- mkTransNoStutter;
   Trans_ifc t2 <- mkTransNoStutter;

   rule transfer;
      let c <- t1.receive;
      t2.send(c);
   endrule

   method Action send(Bit#(1) c);
      t1.send(c);
   endmethod

   method ActionValue#(Bit#(1)) receive;
      let c <- t2.receive;
      return c;
   endmethod

endmodule

(* synthesize *)
module mkTransNoStutter (Trans_ifc);
   Reg#(Bit#(2)) state <- mkReg(0);
   Reg#(Bit#(1)) prev <- mkReg(0);
   FIFO#(Bit#(1)) in_queue <- mkFIFO;
   FIFO#(Bit#(1)) out_queue <- mkFIFO;

   rule state0 (state == 0);
      let c = in_queue.first; in_queue.deq;
      prev <= c;
      state <= 1;
   endrule

   rule state1 (state == 1);
      let c = in_queue.first; in_queue.deq;
      if (prev == c)
         state <= 2;
      else
         state <= 1;
      prev <= c;
   endrule

   rule state2 (state == 2);
      let c = in_queue.first; in_queue.deq;
      if (prev == c) begin
         out_queue.enq(c);
         state <= 0;
         end
      else
         state <= 1;
      prev <= c;
   endrule

   method Action send(Bit#(1) c);
      in_queue.enq(c);
   endmethod

   method ActionValue#(Bit#(1)) receive;
      let c = out_queue.first;
      out_queue.deq;
      return c;
   endmethod

endmodule

endpackage
