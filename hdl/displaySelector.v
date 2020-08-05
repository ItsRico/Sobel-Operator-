
module displaySelector(clk, SW, en_ram, en_sobel, 
gen_addr, vga_addr, data_out, Gx_out, Gy_out, cur_state, red, green, blue, rVGA, bVGA, gVGA, rd_addr);

input clk;

input [2:0] SW;

input en_ram;
input en_sobel; //new

input [9:0] gen_addr;
input [9:0] vga_addr;
input [11:0] data_out; //data stored in RAM
input [11:0] Gx_out;
input [11:0] Gy_out;
input [5:0] cur_state;

input [3:0] red, blue, green;
output reg [3:0] rVGA, bVGA, gVGA;
output reg [9:0] rd_addr;

//This module allows us to designate which output stream from the RAMs to feed to VGA display
always @(*) begin
	// I ended up not using this approach to multiplex between the address to read/write from and the addressess necessary to display to the screen
	//since it caused issues with the ROM table being lost.
	if(cur_state != 6'b001000 | cur_state != 6'b001001) begin //if we are not done, then rd_addr = gen_addr, always
		rd_addr = gen_addr;
	end
	else begin
		rd_addr = vga_addr;
	end
					
	if(en_ram == 1'b1) begin		//if we read from ram, use output of RAM to display to VGA
		bVGA =   data_out[3:0];
		gVGA =  	data_out[7:4];
		rVGA = 	data_out[11:8]; 
	end
	else if( en_sobel == 1'b1) begin //if we are done and want to see what the output of the operator is, we can use display from RAM2
		bVGA =   Gx_out[3:0];
		gVGA =  	Gx_out[7:4];
		rVGA = 	Gx_out[11:8]; 
	end
	else if( SW[0] == 1'b1) begin
		bVGA =   Gy_out[3:0];
		gVGA =  	Gy_out[7:4];
		rVGA = 	Gy_out[11:8]; 
	end else begin
		bVGA =   blue;
		gVGA = 	green;
		rVGA = 	red;
	end
end
endmodule
