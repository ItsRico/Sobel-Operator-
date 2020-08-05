module TB_ROM;//(clk, addr_rd, red, green, blue, tb_data_out);\

	reg [9:0] addr_rd;
	wire [11:0] mem;
	wire [3:0] red;
	wire [3:0] green;
	wire [3:0] blue;

reg rst;
reg clk;
//module ROM(clk, addr_rd, red, green, blue, mem);

ROM UUT( addr_rd, red, green, blue, mem);


initial begin
	rst = 1'b1;
	#300
	
	addr_rd =  10'b00000_00000;

#200

	addr_rd =  10'b00001101;  //10'b00001101: begin mem = 12'b1010_1010_1010; end

#200
	addr_rd =  10'b00000_01000;

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


