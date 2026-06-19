`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class fifo_scb extends uvm_scoreboard;

   `uvm_component_utils(fifo_scb)

   uvm_analysis_imp_wr #(fifo_txn,fifo_scb) wr_imp;
   uvm_analysis_imp_rd #(fifo_txn,fifo_scb) rd_imp;

   bit [7:0] fifo_q[$];

   // Constructor
   function new(string name="fifo_scb",
                uvm_component parent=null);
      super.new(name,parent);

      wr_imp = new("wr_imp",this);
      rd_imp = new("rd_imp",this);
   endfunction

   // ------------------------------------
   // WRITE SIDE
   // ------------------------------------
   function void write_wr(fifo_txn tx);

      foreach(tx.payload[i]) begin

         fifo_q.push_back(tx.payload[i]);

         `uvm_info("SCB_WR",
                   $sformatf("PUSH DATA=%0h FIFO_Q_SIZE=%0d",
                             tx.payload[i],
                             fifo_q.size()),
                   UVM_LOW)

      end

   endfunction

   // ------------------------------------
   // READ SIDE
   // ------------------------------------
   function void write_rd(fifo_txn tx);

      bit [7:0] exp_data;

      if(fifo_q.size() == 0) begin

         `uvm_error("FIFO_SCB",
                    "READ HAPPENED BUT SCOREBOARD QUEUE EMPTY")
         return;

      end

      exp_data = fifo_q.pop_front();

      `uvm_info("SCB_RD",
                $sformatf("POP EXP=%0h ACT=%0h FIFO_Q_SIZE=%0d",
                          exp_data,
                          tx.read_data,
                          fifo_q.size()),
                UVM_LOW)

      if(exp_data === tx.read_data) begin

         `uvm_info("FIFO_SCB",
                   $sformatf("DATA MATCH EXP=%0h ACT=%0h",
                             exp_data,
                             tx.read_data),
                   UVM_LOW)

      end
      else begin

         `uvm_error("FIFO_SCB",
                    $sformatf("DATA MISMATCH EXP=%0h ACT=%0h",
                              exp_data,
                              tx.read_data))

      end

   endfunction

endclass
