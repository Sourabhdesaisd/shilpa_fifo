/*class fifo_read_agent extends uvm_agent;

   `uvm_component_utils(fifo_read_agent)

   fifo_read_sequencer seqr;
   fifo_read_driver    drv;
   fifo_read_monitor   mon;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      seqr = fifo_read_sequencer::type_id::create("seqr", this);
      drv  = fifo_read_driver   ::type_id::create("drv",  this);
      mon  = fifo_read_monitor  ::type_id::create("mon",  this);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      drv.seq_item_port.connect(seqr.seq_item_export);
   endfunction

endclass */

class fifo_read_agent extends uvm_agent;

  `uvm_component_utils(fifo_read_agent)

  fifo_read_sequencer sqr;
  fifo_read_driver    drv;
  fifo_read_monitor   mon;

  function new(string name = "fifo_read_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    sqr = fifo_read_sequencer::type_id::create("sqr", this);
    drv = fifo_read_driver   ::type_id::create("drv", this);
    mon = fifo_read_monitor  ::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass
