module memory( clk, rd_en, wr_en, wr_addr, wr_data, rd_addr, data_out);

input clk, rd_en, wr_en;
input [9:0] wr_addr; 
input [11:0] wr_data;
input [9:0] rd_addr;
output reg [11:0] data_out;

/* synthesis preserve */
reg [11:0] mem [0:1023] ;

//This is also synthesized as DUAL port RAM, stores both the horizontal and vertical components of the Sobel Operator

always @(posedge clk) begin

	if( wr_en == 1'b1) begin
		mem[wr_addr] <= wr_data;  // wr_addr 0 - 3 
	end
	if( rd_en == 1'b1) begin
		data_out = mem[rd_addr];
	end
	
end



endmodule
