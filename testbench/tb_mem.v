module TB_MEMORY;

reg rst;
reg clk;
reg wr_en2;

reg sobel_en2;
reg [9:0] wr_addr; 
reg [11:0] wr_data;
reg [9:0] rd_addr;
wire [11:0] data_out;
wire [3:0] wr_gx;
wire [3:0] wr_gy;
wire sobel_done;

//module memOp( clk, wr_en,sobel_en, wr_addr, wr_data, rd_addr, data_out, wr_gx,  wr_gy, sobel_done);

 memOp sobelgray( clk, wr_en2,sobel_en2, wr_addr, wr_data, rd_addr, data_out, wr_gx,  wr_gy, sobel_done);


initial begin
	rst = 1'b1;
	#300;
	rst = 1'b0;
	wr_en2 = 1'b0;	
	rd_addr =  10'b00000_00000;
	wr_addr = 10'b00000_00000;
	wr_data = 12'b1111_1111_1111;
	#200;
	rd_addr =  10'b00000_00000;
	
	//rd_addr =  10'b00001101;  //10'b00001101: begin mem = 12'b1010_1010_1010; end
	wr_data = 12'b1010_1010_1010;
	wr_addr = 10'b00000_00001;
	#200;
	rd_addr =  10'b00000_00001;
	//rd_addr =  10'b00001101;  //10'b00001101: begin mem = 12'b1010_1010_1010; end
	wr_data = 12'b1010_1010_1111;
	wr_addr = 10'b00000_00010;
#200;
	rd_addr =  10'b00000_00010;
	wr_data = 12'b1010_1010_1111;
	wr_addr = 10'b00000_00011;
#200 
	sobel_en2 = 1'b1;
	
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

