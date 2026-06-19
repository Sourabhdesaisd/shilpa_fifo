/*class fifo_parallel_seq extends uvm_sequence;

  `uvm_object_utils(fifo_parallel_seq)
  //`uvm_declare_p_sequencer(fifo_virtual_seqr)
  `uvm_declare_p_sequencer(fifo_virtual_sequencer)
  function new(string name = "fifo_parallel_seq");
    super.new(name);
  endfunction

  task body();

    fork

      // WRITE THREAD
      begin
        fifo_write_seq wr_seq;
        wr_seq = fifo_write_seq::type_id::create("wr_seq");
        wr_seq.start(p_sequencer.wr_seqr);
      end

      // READ THREAD
      begin
        fifo_read_seq rd_seq;
        rd_seq = fifo_read_seq::type_id::create("rd_seq");
        rd_seq.start(p_sequencer.rd_seqr);
      end

    join

  endtask 



task body();

  fork

    // WRITE THREAD
    begin
      fifo_write_seq wr_seq;

      wr_seq = fifo_write_seq::type_id::create("wr_seq");
      wr_seq.start(p_sequencer.wr_seqr);
    end

    // READ THREAD
    begin
      fifo_read_seq rd_seq;

      rd_seq = fifo_read_seq::type_id::create("rd_seq");
      rd_seq.start(p_sequencer.rd_seqr);
    end

  join

endtask */




class fifo_parallel_seq extends uvm_sequence;

  `uvm_object_utils(fifo_parallel_seq)
  //`uvm_declare_p_sequencer(fifo_virtual_seqr)
  `uvm_declare_p_sequencer(fifo_virtual_sequencer)
  function new(string name = "fifo_parallel_seq");
    super.new(name);
  endfunction

  task body();

    fork

      // WRITE THREAD
      begin
        fifo_write_seq wr_seq;
        wr_seq = fifo_write_seq::type_id::create("wr_seq");
        wr_seq.start(p_sequencer.wr_seqr);
      end

      // READ THREAD
      begin
        fifo_read_seq rd_seq;
        rd_seq = fifo_read_seq::type_id::create("rd_seq");
        rd_seq.start(p_sequencer.rd_seqr);
      end

    join

  endtask

endclass
