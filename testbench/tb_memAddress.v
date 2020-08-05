module tb_adresssing;



reg clk,wr_en, rd_en;
reg rst;
reg sobel_en;
reg [9:0] wr_addr; 
reg [11:0] wr_data;
reg [9:0] rd_addr;
wire[11:0] data_out;
wire[3:0] wr_gx;
wire [3:0] wr_gy;
wire sobel_done;
//output reg sobel_done;



/* synthesis preserve */
reg [11:0] mem [0:1023] ;	
						//	         168421  
localparam thirty4 = 10'b0000_100010;
localparam thirty3 = 10'b0000_100001;
localparam thirty2 = 10'b0000_100000;
localparam thirty1 = 10'b00000_11111;
//convolution kernel for applying sobel


integer i;
 memOp UUT( clk, wr_en,rd_en, sobel_en, wr_addr, wr_data, i, data_out, wr_gx,  wr_gy, sobel_done);


initial begin 
rst = 1'b1;
#300;
rst = 1'b0;
sobel_en = 1'b1;
rd_en = 1'b1;


for ( i = 0; i < 1023; i = i + 1) begin
 $display( "i:%i " , i);
#100;

end

$stop;
end	



always begin
	if(rst == 1'b1) begin
		clk = 1'b0;
	#1;
	end
	else begin
	#100;
	clk = ~clk;
	end
end
endmodule
	