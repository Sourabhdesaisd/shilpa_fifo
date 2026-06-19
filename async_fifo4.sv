//Asynchronous fifo
module async_fifo(
		  wr_clk,
		  rd_clk,
		  reset,
		  wr_en,
		  rd_en,
		  write_data,
		  read_data,
		  full,
		  empty,
		  transfer_flag
		  );
	//parameters 
	parameter WRITE_WIDTH =8;                   // data width
	parameter READ_WIDTH = 8;
	parameter FIFO_DEPTH  =16;                 // fifo depth
	parameter PTR_WIDTH  =$clog2(FIFO_DEPTH);//7  //width of pointers

	input wr_clk;							   //input write clk
	input rd_clk;							   //input read clk
	input reset;							   //input reset
	input wr_en;							   //wr_en 1 for write operation
	input rd_en;							   //rd_en 1 for read operation
	input[WRITE_WIDTH-1:0]write_data;           //input write data of width DATA_WIDTH

	output reg [READ_WIDTH-1:0]read_data;	   //output read_data of width DATA_WIDTH
    output reg full;						   //full is 1 when write happens to the FIFO which is already full(means already write happens to all the locations)
	output reg empty;						   //empty is 1 when read hapens to the FIFO which is already red out.
	output reg transfer_flag;

	//pointers for write and read operation
	reg[PTR_WIDTH-1:0]write_ptr;			   //write_ptr is a pointer used for the write operation on FIFO
	reg[PTR_WIDTH-1:0]write_ptr_rd_clk;		   //write_ptr_rd_clk is pointer for CDC
	reg[PTR_WIDTH-1:0]read_ptr;				   //read_ptr is pointer used for the read operation on FIFO
	reg[PTR_WIDTH-1:0]read_ptr_wr_clk;		   //read_ptr_wr_clk is pointer for CDC

	//registers for roll-over
	reg write_toggle;						   //write_toggle for write roll-over
	reg write_toggle_rd_clk;				   //write_toggle_rd_clk for CDC
	reg read_toggle;						   //read_toggle for read roll-over
	reg read_toggle_wr_clk;					   //read_toggle_wr_clk for CDC
	
	reg [PTR_WIDTH-1:0]write_gray_ptr;
	reg [PTR_WIDTH-1:0]read_gray_ptr;
	reg [WRITE_WIDTH-1:0] fifo [FIFO_DEPTH-1:0]; //fifo register array

	integer i;									//iterative variable

	always@(posedge wr_clk or negedge reset)begin					//synchronous reset for write operation on wr_clk
		if(!reset)begin															//all the outputs and registers will be 0 when reset is 1
			write_ptr    <='b0;
			write_toggle <='b0;
			for(i=0;i<FIFO_DEPTH;i=i+1)fifo[i]<=0; //resetting the fifo to 0
		end
		else begin
				if(wr_en==1)begin												// wr_en is 1 for write operation
					if(full==0)begin											//if full is 1 wr_error will be 1
						fifo[write_ptr]<=write_data;							//write operation at write_ptr location
						if(write_ptr==FIFO_DEPTH-1) write_toggle<=~write_toggle;// every time wr_ptr is equal to FIFO_DEPTH-1 write_toggle will toggles
							write_ptr<=write_ptr+1'b1;								//incrementing the write_ptr for further write opeartion
					end
				end
		end
	end

	assign write_gray_ptr = {write_ptr[PTR_WIDTH-1],write_ptr[PTR_WIDTH-1:1]^write_ptr[PTR_WIDTH-2:0]};
	assign read_gray_ptr ={read_ptr[PTR_WIDTH-1],read_ptr[PTR_WIDTH-1:1]^read_ptr[PTR_WIDTH-2:0]};

	always@(posedge rd_clk or negedge reset)begin											  //synchronous reset for read operation on rd_clk
		if(!reset)begin												  //when reset is 0
			read_data <= 'b0;
			read_ptr <= 'b0;
			read_toggle <= 'b0;
		end
		else begin
			if(rd_en==1)begin											  //rd_en is 1 for read operation
				if(empty==0)begin										  //if empty is 1 rd_error will be 1
					read_data<=fifo[read_ptr];                            //reading the fifo through read_ptr
					if(read_ptr==FIFO_DEPTH-1)read_toggle<=~read_toggle;  //every time read_ptr is equal to FIFO_DEPTH-1 read_toggle will toggles
						read_ptr<=read_ptr+1'b1;                             //increamenting the read_ptr for further read operation 
				end
			end
		end
	end

	//synchronization of write_ptr and write_toggle on rd_clk
	always@(posedge rd_clk or negedge reset)begin
		if(!reset)begin
			write_ptr_rd_clk <= 'b0;
			write_toggle_rd_clk <= 'b0;
		end
		else begin
			write_ptr_rd_clk<=write_gray_ptr;
			write_toggle_rd_clk<=write_toggle;
		end
	end
	//synchronization of read_ptr and read_toggle on wr_clk
	always@(posedge wr_clk or negedge reset)begin
		if(!reset)begin
			read_ptr_wr_clk <= 'b0;
			read_toggle_wr_clk <= 'b0;
		end
		else begin
			read_ptr_wr_clk<=read_gray_ptr;
			read_toggle_wr_clk<=read_toggle;
		end
	end
	always_comb begin	
		full =0;		//initializing full and empty to 0		
		empty=1;
		if(write_ptr_rd_clk==read_gray_ptr && write_toggle_rd_clk==read_toggle)empty=1; //condition for empty
		else empty=0;
		if(write_gray_ptr==read_ptr_wr_clk && write_toggle!=read_toggle_wr_clk)full=1;  //condition for full
		else full=0;
	end

	assign transfer_flag = (write_gray_ptr && ~empty) ? 1'b1 : 1'b0;
endmodule
