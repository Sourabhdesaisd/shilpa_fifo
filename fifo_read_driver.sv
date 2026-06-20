

class fifo_read_driver extends uvm_driver #(fifo_txn);

  `uvm_component_utils(fifo_read_driver)

  virtual fifo_intf vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual fifo_intf)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for read driver")
  endfunction

  task run_phase(uvm_phase phase);

    fifo_txn req;

    forever begin

      seq_item_port.get_next_item(req);

      vif.rd_en <= 0;

      if(req.rd_en) begin

        foreach(req.payload[i]) begin

          repeat(req.rd_delay[i])
            @(posedge vif.rd_clk);


            //@(posedge vif.rd_clk);


          if(!vif.empty) begin

            `uvm_info("RD_DRV",
                      $sformatf("READ_REQ DATA[%0d] EMPTY=%0b",
                                i, vif.empty),
                      UVM_LOW)

            vif.rd_en <= 1;

            @(posedge vif.rd_clk);

            vif.rd_en <= 0;

          end
          else begin

            `uvm_info("RD_DRV",
                      $sformatf("FIFO EMPTY DATA[%0d]", i),
                      UVM_LOW)

            vif.rd_en <= 0;

          end

        end

      end

      seq_item_port.item_done();

    end

  endtask

endclass
