class fifo_read_seq extends fifo_base_seq;

  `uvm_object_utils(fifo_read_seq)

  function new(string name = "fifo_read_seq");
    super.new(name);
  endfunction
task body();



 repeat(1000) begin

   req = fifo_txn::type_id::create("req");

   start_item(req);

   assert(req.randomize() with {
      wr_en == 0;
      rd_en == 1;
   });

   finish_item(req);

 end

endtask
  endclass
