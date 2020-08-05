module addressGen(clk, rst, gen_en, sobel_en, addr, done);
						///      when enabled, will generate address values from 0 to 1023, essentially a counter
						///		then will raise done to high
						
						
input clk, rst, gen_en,sobel_en;
output reg [9:0] addr;
output reg done;


reg [9:0] c_addr;
//reg [3:0] state, state_c; 
reg lock;

initial addr = 10'b00000_00000;
/*initial state_c = 3'b000;


localparam IDLE 		=	3'b000;
localparam COUNTING_G  =	3'b001;
localparam COUNTING_S  =	3'b010;

localparam WAIT_G		=	3'b100;
localparam WAIT_S		=	3'b101;
	*/
	
//design idea:
//when enabled, begin counting
//when done counting, stay in high, when enabled again

/*
always @(*) begin
 state <= state_c;

	case(state) 
				IDLE:begin
					if( gen_en == 1'b1) begin
						state_c <= COUNTING_G;
						done = 1'b0;

					end
					else if(sobel_en == 1'b1) begin
						state_c <= COUNTING_S;
						done = 1'b0;

					end
					else begin
						done = 1'b0;
						c_addr = 10'b00000_00000;
					end
				end
				COUNTING_G: begin
					if(addr == 	10'b11111_11111) begin
						state_c <= WAIT_G;
						done = 1'b1;
					end else
					if( addr < 10'b11111_11111) begin 
						done = 1'b0;
						c_addr = addr + 10'b00000_00001;
						state_c <= COUNTING_G;
					end
				end
				COUNTING_S: begin
					if(addr == 	10'b11111_11111) begin
						state_c <= WAIT_S;
						done = 1'b1;
					end else
					if( addr < 10'b11111_11111) begin 
						done = 1'b0;
						c_addr = addr + 10'b00000_00001;
						state_c <= COUNTING_S;
					end
				end
				


//		This should help deal with timing violations				
				WAIT_S:
				begin
					c_addr =  10'b00000_00000;
					done = 1'b1;
					if(sobel_en == 1'b0) begin
						state_c <= IDLE;
					end
				end
				WAIT_G:
				begin
					c_addr =  10'b00000_00000;
					done = 1'b1;
					if(gen_en == 1'b0) begin
						state_c <= IDLE;
					end
				end				
	endcase
end*/


always @( posedge clk) begin
 addr <= c_addr; //default
end
//need to add reset case
//the init thing doesn't seeem to really work other than for debugging, i think a better 
//fail-safe would be to have an exception case for the module reading or writing addresses
// *if the address is out of range, then stop*
always @(*) begin 
	done = 0;

	if((gen_en == 1'b1 | sobel_en == 1'b1) & lock == 1'b0) begin
			if( addr < 10'b11111_11111) begin 
				done = 1'b0;
				lock = 1'b0;
				c_addr = addr + 10'b00000_00001;
			end
			else begin
				lock = 1'b1;
				done = 1'b1;
				c_addr = 10'b00000_00000;
			end
	end else
	begin
		done = 1'b0;
		lock = 1'b0;
		c_addr = 10'b00000_00000;
	end
	
		if(rst == 1'b1) begin
			c_addr = 10'b00000_00000;
			done = 1'b0;
			lock = 1'b0;
		end
end


endmodule

	

						