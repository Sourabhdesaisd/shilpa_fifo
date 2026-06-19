interface fifo_intf(input wr_clk, rd_clk, reset);

  logic wr_en;
  logic rd_en;
  logic [7:0] write_data;

  logic [7:0] read_data;
  logic full;
  logic empty;
  logic transfer_flag;


  // Write Driver clocking block
  clocking wr_drv_cb @(posedge wr_clk);
    default input #1 output #0;
    input full;
    input empty;
    input transfer_flag;
    output wr_en;
    output write_data;
  endclocking


  // Read Driver clocking block
  clocking rd_drv_cb @(posedge rd_clk);
    default input #1 output #0;
    input full;
    input empty;
    input transfer_flag;
    output rd_en;
  endclocking


  // Write Monitor clocking block
    
  clocking wr_mon_cb @(posedge wr_clk);
  default input #1step;
  input wr_en;
  input write_data;
  input full;
  input empty;
  input transfer_flag;
endclocking

  // Read Monitor clocking block

clocking rd_mon_cb @(posedge rd_clk);
  default input #1step;
  input rd_en;
  input read_data;
  input full;
  input empty;
  input transfer_flag;
endclocking
endinterface
