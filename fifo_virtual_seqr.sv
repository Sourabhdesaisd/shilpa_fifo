class fifo_virtual_sequencer extends uvm_sequencer;

  `uvm_component_utils(fifo_virtual_sequencer)

  // Handles to real sequencers
  fifo_write_sequencer wr_seqr;
  fifo_read_sequencer  rd_seqr;

  function new(string name = "fifo_virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
