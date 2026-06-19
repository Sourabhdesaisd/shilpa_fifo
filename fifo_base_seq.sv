`include "uvm_macros.svh"
import uvm_pkg::*;
class fifo_base_seq extends uvm_sequence #(fifo_txn);

   `uvm_object_utils(fifo_base_seq)

   function new(string name = "fifo_base_seq");
      super.new(name);
   endfunction

   //=====================================
   // PRE BODY (RAISE OBJECTION)
   //=====================================
   task pre_body();
      if (starting_phase != null) begin
         starting_phase.raise_objection(this);
         starting_phase.phase_done.set_drain_time(this, 100);
      end
   endtask

   //=====================================

   // POST BODY (DROP OBJECTION)
   //=====================================
   task post_body();
      if (starting_phase != null) begin
         starting_phase.drop_objection(this);
      end
   endtask

endclass


