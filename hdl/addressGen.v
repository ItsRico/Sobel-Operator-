module addressGen(clk, rst, gen_en, sobel_en, addr, done);
						///      when enabled, will generate address values from 0 to 1023, essentially a counter
						///		then will raise done to high
						
/// for a more robust implemenation, the size of address counter could be parameterized to be suitable for the desired image size						
input clk, rst, gen_en,sobel_en;
output reg [9:0] addr;
output reg done;


reg [9:0] c_addr;
//reg [3:0] state, state_c; 
reg lock;


initial addr = 10'b00000_00000;



always @( posedge clk) begin
 addr <= c_addr; //default
end
//The only issue with this module is that the  period for which it asynchronously asserts high is very small and caused some issues with the FSM.
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

	

						