class fifo_write_driver extends uvm_driver #(fifo_txn);

  `uvm_component_utils(fifo_write_driver)

  virtual fifo_intf vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual fifo_intf)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for write driver")
  endfunction

task run_phase(uvm_phase phase);

  fifo_txn req;

  forever begin

    seq_item_port.get_next_item(req);

    vif.wr_en <= 0;

    if (req.wr_en) begin

      foreach (req.payload[i]) begin

       
        repeat(req.wr_delay[i])
          @(posedge vif.wr_clk);

        if (!vif.full) begin

          vif.wr_en      <= 1;
          vif.write_data <= req.payload[i];

          @(posedge vif.wr_clk);

          vif.wr_en <= 0;

        end

      end

    end

    seq_item_port.item_done();

  end

endtask

endclass
