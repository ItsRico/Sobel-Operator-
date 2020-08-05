module TB_addressGen;
						///      when enabled, will generate address values from 0 to 1023, essentially a counter
						///		then will raise done to high
reg clk, rst, gen_en,sobel_en;
wire [9:0] addr;
wire done;

reg [9:0] c_addr;

//module addressGen(clk, rst, gen_en, sobel_en, addr, done);

addressGen UUT(clk, rst, gen_en, sobel_en, addr, done);

initial begin
	rst = 1'b1;
	#300;
	rst = 1'b0;
	gen_en = 1'b1;	
	#2000;
   #50000;
	#1000;
	#50000;
	#50000;// gets to 10000_00000 
	#50000;// 1111110111
	#2000;
	gen_en = 1'b0;
	sobel_en = 1'b1;
	
	#2000;
	
	
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

