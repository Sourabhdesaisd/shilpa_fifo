`include "uvm_macros.svh"
import uvm_pkg::*;
class fifo_write_monitor extends uvm_monitor;

  uvm_analysis_port #(fifo_txn) ap_port;

  virtual fifo_intf vif;

  fifo_txn tx_1;

  `uvm_component_utils(fifo_write_monitor)

  function new(string name = "fifo_write_monitor", uvm_component parent);
    super.new(name, parent);
    ap_port = new("ap_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual fifo_intf)::get(this, "", "vif", vif))
      `uvm_info(get_type_name(), "failed to get using config db", UVM_NONE)
    else
      `uvm_info(get_type_name(), "successfully get using config db", UVM_NONE)
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
     /* @(vif.wr_mon_cb);
      begin
        tx_1 = fifo_txn::type_id::create("tx_1");

        tx_1.wr_en         = vif.wr_mon_cb.wr_en;
        tx_1.full          = vif.wr_mon_cb.full;
        tx_1.empty         = vif.wr_mon_cb.empty;
        tx_1.transfer_flag = vif.wr_mon_cb.transfer_flag;

        if(vif.wr_mon_cb.wr_en && !vif.wr_mon_cb.full) begin

  tx_1.payload = new[1];
  tx_1.payload[0] = vif.wr_mon_cb.write_data;

  `uvm_info("WR_MON",
            $sformatf("WRITE_DATA=%0h", tx_1.payload[0]),
            UVM_LOW)

  ap_port.write(tx_1);

end */

@(vif.wr_mon_cb);

if(vif.wr_mon_cb.wr_en && !vif.wr_mon_cb.full) begin

   @(vif.wr_mon_cb);

   tx_1 = fifo_txn::type_id::create("tx_1");

   tx_1.payload = new[1];
   tx_1.payload[0] = vif.wr_mon_cb.write_data;

   `uvm_info("WR_MON",
             $sformatf("WRITE_DATA=%0h",
                       tx_1.payload[0]),
             UVM_LOW)

   ap_port.write(tx_1);



      end
    end
  endtask

endclass
