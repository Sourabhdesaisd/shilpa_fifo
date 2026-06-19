


module fifo_top;

 import uvm_pkg::*;

  reg wr_clk;
  reg rd_clk;
  reg reset;

  initial begin
    wr_clk = 0;
    forever #1 wr_clk = ~wr_clk;
  end

  initial begin
    rd_clk = 0;
    forever #1 rd_clk = ~rd_clk;
  end

  initial begin
    reset = 0;
    repeat(2) @(posedge wr_clk);
    reset = 1;
  end

  fifo_intf pif(wr_clk, rd_clk, reset);

  async_fifo dut (
    .wr_clk(pif.wr_clk),
    .rd_clk(pif.rd_clk),
    .reset(pif.reset),
    .wr_en(pif.wr_en),
    .rd_en(pif.rd_en),
    .write_data(pif.write_data),
    .read_data(pif.read_data),
    .full(pif.full),
    .empty(pif.empty),
    .transfer_flag(pif.transfer_flag)
  );

  initial begin
    uvm_config_db#(virtual fifo_intf)::set(null, "*", "vif", pif);
  end

  initial begin
    run_test("");
  end

   initial begin
      $shm_open("wave.shm");
      $shm_probe("ACTMF");
   end


endmodule
