module FSM(clk, rst, SW, w_en1, w_en2, w_en3);


input clk, rst;
input [4:0] SW;

output w_en1, w_en2, w_en3;
output [9:0] LEDR;

localparam RESET = 1'h0;
localparam RED  = 1'h1;
localparam BLUE  = 1'h1;
localparam GREEN  = 1'h1;


always@(posedge clk) begin
	state <= state_c;
end
/// SW[0] for 
always @(*) begin
case(state)
	RESET: begin
			if(SW[0] == 1'b1) begin			
				state_c = RED;
			end else if(SW[1] == 1'b1) begin
				state_c = BLUE;
			end else if(SW[2] == 1'b1) begin
				state_c = GREEN;
			end
				else begin
				 LEDR[0] = 1'b1;
				 LEDR[1] = 1'b0;
				state_c = RESET;
				end
		end//
	RED: begin
		if( rst == 1'b1) begin
			state_c = RESET
		else begin
			state_c = RED;
			LEDR[0] = 1'b0;
			LEDR[1] = 1'b1;
			LEDR[2] = 1'b0;
		end
	BLUE:	
		begin
		if( rst == 1'b1) begin
			state_c = RESET
		else begin
			state_c = BLUE;
			LEDR[0] = 1'b0;
			LEDR[1] = 1'b1;
			LEDR[2] = 1'b0;
		end
	GREEN:	
		begin
		if( rst == 1'b1) begin
			state_c = RESET
		else begin
			state_c = GREEN;
			LEDR[0] = 1'b0;
			LEDR[1] = 1'b1;
			LEDR[2] = 1'b0;
		end		
end

endmodule


