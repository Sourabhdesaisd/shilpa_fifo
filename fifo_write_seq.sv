
class fifo_write_seq extends fifo_base_seq;

  `uvm_object_utils(fifo_write_seq)

  function new(string name = "fifo_write_seq");
    super.new(name);
  endfunction
  
  task body();



 repeat(1000) begin

   req = fifo_txn::type_id::create("req");

   start_item(req);

   assert(req.randomize() with {
      wr_en == 1;
      rd_en == 0;
   });

   finish_item(req);

 end

endtask

endclass
