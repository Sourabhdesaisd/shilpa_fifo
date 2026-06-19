`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_txn extends uvm_sequence_item;

  rand bit [7:0] payload[];

  rand int unsigned size;
  rand int unsigned wr_delay[];
  rand int unsigned rd_delay[];

  rand bit wr_en;
  rand bit rd_en;

  bit [7:0] read_data;

  bit full;
  bit empty;
  bit transfer_flag;

  constraint size_c {
    size inside {[8:16]};
  }

  constraint en_c {
   wr_en dist {1:=50, 0:=50};
   rd_en dist {1:=50, 0:=50};
}

  constraint payload_size_c {
    payload.size() == size;
  }

  constraint wr_delay_size_c {
    wr_delay.size() == payload.size();
  }

  constraint rd_delay_size_c {
    rd_delay.size() == payload.size();
  }

  constraint payload_c {
    foreach(payload[i])
      payload[i] inside {[8'h00:8'hFF]};
  }

  constraint wr_delay_c {
    foreach(wr_delay[i])
      wr_delay[i] inside {[0:15]};
  }

  constraint rd_delay_c {
    foreach(rd_delay[i])
      rd_delay[i] inside {[0:15]};
  }

  `uvm_object_utils_begin(fifo_txn)
    `uvm_field_int(size, UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_array_int(wr_delay, UVM_ALL_ON)
    `uvm_field_array_int(rd_delay, UVM_ALL_ON)
    `uvm_field_int(wr_en, UVM_ALL_ON)
    `uvm_field_int(rd_en, UVM_ALL_ON)
    `uvm_field_int(read_data, UVM_ALL_ON)
    `uvm_field_int(full, UVM_ALL_ON)
    `uvm_field_int(empty, UVM_ALL_ON)
    `uvm_field_int(transfer_flag, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "fifo_txn");
    super.new(name);
  endfunction

endclass
