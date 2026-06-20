class fifo_read_monitor extends uvm_monitor;

  uvm_analysis_port #(fifo_txn) ap_port;

  virtual fifo_intf vif;

  fifo_txn tx_1;

  `uvm_component_utils(fifo_read_monitor)

  function new(string name = "fifo_read_monitor",
               uvm_component parent);
    super.new(name, parent);
    ap_port = new("ap_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual fifo_intf)::get(this, "", "vif", vif))
      `uvm_info(get_type_name(),
                "failed to get using config db",
                UVM_NONE)
    else
      `uvm_info(get_type_name(),
                "successfully get using config db",
                UVM_NONE)
  endfunction

/*  task run_phase(uvm_phase phase);

   fifo_txn tx_1;

   forever begin

      // Detect accepted read
      @(vif.rd_mon_cb);

      if(vif.rd_mon_cb.rd_en && !vif.rd_mon_cb.empty) begin

         // Wait one more read clock for valid read_data
         @(vif.rd_mon_cb);

         tx_1 = fifo_txn::type_id::create("tx_1");

         tx_1.read_data = vif.rd_mon_cb.read_data;

         `uvm_info("RD_MON",
                   $sformatf("READ_DATA=%0h",
                             tx_1.read_data),
                   UVM_LOW)

         ap_port.write(tx_1);

      end

   end

endtask*/

//bit first_read = 1;


/*task run_phase(uvm_phase phase);

   forever begin

      @(vif.rd_mon_cb);


      if(vif.rd_mon_cb.rd_en && !vif.rd_mon_cb.empty) begin

         tx_1 = fifo_txn::type_id::create("tx_1");

         tx_1.read_data = vif.rd_mon_cb.read_data;

         `uvm_info("RD_MON",
                   $sformatf("READ_DATA=%0h",
                             tx_1.read_data),
                   UVM_LOW)

         ap_port.write(tx_1);

      end

   end

endtask*/
task run_phase(uvm_phase phase);

  bit pending_read;

  pending_read = 0;

  forever begin

    @(posedge vif.rd_clk);

    if(pending_read) begin

      tx_1 = fifo_txn::type_id::create("tx_1");

      tx_1.read_data = vif.read_data;

      `uvm_info("RD_MON",
                $sformatf("READ_DATA=%0h",
                          tx_1.read_data),
                UVM_LOW)

      ap_port.write(tx_1);

      pending_read = 0;
    end

    if(vif.rd_en && !vif.empty)
      pending_read = 1;

  end

endtask

endclass
