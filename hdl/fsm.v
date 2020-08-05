module FSM(clk, rst ,SW, gen_done,sobel_done, gray_en, sobel_en, state);

input clk, rst,SW;
input gen_done, sobel_done; 
output reg gray_en, sobel_en;

parameter  	RESET 			 = 		6'b000000;
parameter 	IDLE 				 = 		6'b000001;
parameter 	SETUP 			 = 		6'b000010;
parameter 	SOBEL 			 = 		6'b000100;
parameter 	DONE 				 = 		6'b001000;
output reg [5:0] state;
reg [5:0]  state_c; //will let me select display



always @(posedge clk) begin
	state <= state_c;
end
initial state_c <= 6'b000000;
initial state <= 6'b000000;


// The FSM for this system is very simple, and linear. During the SETUP Phase, the grayscale is computed. Originally, it was fed the signal gen_done, but because of 
//clock synchonization issues (add_gen clocked at 25 MHz and fsm at 50 Hz), I decided to manually change the state with the switch.
always @(*) begin
		if( rst == 1'b1) begin
			state_c <= 6'b000000;
		end else begin

	sobel_en = 1'b0;
	gray_en = 1'b0;
	case(state)
		RESET: begin
			sobel_en = 1'b0;
			gray_en = 1'b0;
			state_c <= SETUP;
		end
		SETUP:
			begin
					if(SW == 1'b1) begin
						state_c <= IDLE;
						gray_en = 1'b0;
						sobel_en = 1'b0;
					end
					else begin
						state_c <= SETUP;
						gray_en = 1'b1;
						sobel_en = 1'b0 ;
					end
			end
		IDLE: 
			begin
					if(gen_done == 1'b0 & sobel_done == 1'b0) begin // in this idle state, waits for any metastable conditions in the system to subside before proceeeding to SOBEL
						state_c <=  SOBEL;
						sobel_en = 1'b0;
						gray_en = 1'b0;
					end
					else begin
						sobel_en = 1'b0;
						gray_en = 1'b0;
						state_c <= #1 IDLE;
					end
			end
		SOBEL:
			begin
					//if(sobel_done == 1'b1 | gen_done == 1'b1) begin /// takes the output from mem.v where the algorithm is preformed
					if(sobel_done == 1'b1) begin
						state_c <= DONE;
						sobel_en = 1'b1;
						gray_en = 1'b0;
					end
					else begin
						sobel_en = 1'b1; //8/2 addition
						gray_en = 1'b0;
						state_c <= #1 SOBEL;
						// waiting for sobel to finish
					end
			end
		DONE:
			begin 
					sobel_en = 1'b0;
					gray_en = 1'b0;
					state_c <= DONE;
			end
		default:begin
				state_c <= #1 6'b110110;
				sobel_en = 1'b0;
				gray_en = 1'b0;
			
		end
		endcase
	end
end


endmodule


