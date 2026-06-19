
/*class fifo_env extends uvm_env;

  `uvm_component_utils(fifo_env)

  fifo_write_agent wr_agent;
  fifo_read_agent  rd_agent;

  fifo_virtual_sequencer v_seqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    wr_agent = fifo_write_agent::type_id::create("wr_agent", this);
   rd_agent = fifo_read_agent::type_id::create("rd_agent", this);

    v_seqr   = fifo_virtual_sequencer::type_id::create("v_seqr", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect real sequencers to virtual sequencer
    v_seqr.wr_seqr = wr_agent.sqr;
    v_seqr.rd_seqr = rd_agent.sqr;

  endfunction

endclass*/

class fifo_env extends uvm_env;

  `uvm_component_utils(fifo_env)

  fifo_write_agent      wr_agent;
  fifo_read_agent       rd_agent;
  fifo_virtual_sequencer v_seqr;
  fifo_scb              scb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    wr_agent = fifo_write_agent::type_id::create("wr_agent", this);
    rd_agent = fifo_read_agent::type_id::create("rd_agent", this);

    v_seqr   = fifo_virtual_sequencer::type_id::create("v_seqr", this);
    scb      = fifo_scb::type_id::create("scb", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect real sequencers to virtual sequencer
    v_seqr.wr_seqr = wr_agent.sqr;
    v_seqr.rd_seqr = rd_agent.sqr;

    // Connect monitors to scoreboard
    wr_agent.mon.ap_port.connect(scb.wr_imp);
    rd_agent.mon.ap_port.connect(scb.rd_imp);

  endfunction

endclass
