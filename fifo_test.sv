
class fifo_test extends uvm_test;

  `uvm_component_utils(fifo_test)

  // Environment handle
  fifo_env env;

  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = fifo_env::type_id::create("env", this);

  endfunction

  // Run phase
  task run_phase(uvm_phase phase);

  fifo_parallel_seq seq;

  phase.raise_objection(this);

  seq = fifo_parallel_seq::type_id::create("seq");

  seq.start(env.v_seqr);

  phase.drop_objection(this);

endtask
  endclass

