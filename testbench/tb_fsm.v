module TB_FSM;//(clk, addr_rd, red, green, blue, tb_data_out);\



reg clk, rst;

reg gen_done, sobel_done; 
wire gray_en, sobel_en;

wire [5:0] state;

 FSM uut(clk, rst , gen_done,sobel_done, gray_en, sobel_en, state);


initial begin
	rst = 1'b1;
	#300
	rst = 1'b0;

#200;

#200;
	rst = 1'b0;

	//state 2
#200;
#200;
	rst = 1'b1;

#200;
	rst = 1'b0;


#200;
#200;
	
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
