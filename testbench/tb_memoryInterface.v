module tb_MEMINTERFACE;


reg clk, rst;

reg gen_done, sobel_done; 
wire gray_en, sobel_en;

wire [5:0] state;

FSM fsm(clk, rst , gen_done,sobel_done, gray_en, sobel_en, state);

reg gen_en;
wire [9:0] addr;
wire done;

reg [9:0] c_addr;

//module addressGen(clk, rst, gen_en, sobel_en, addr, done);

addressGen ADDGEN(clk, rst, gen_en, sobel_en, addr, done);



wire [11:0] mem;
wire [3:0] red;
wire [3:0] green;
wire [3:0] blue;


ROM rom( addr, red, green, blue, mem);



reg wr_en, rd_en;

reg [9:0] wr_addr; 
reg [11:0] wr_data;
reg [9:0] rd_addr;
wire [11:0] data_out;
wire [3:0] wr_gx;
wire [3:0] wr_gy;

memOp Gray( clk, gray_en,rd_en, sobel_en, addr, wr_data, addr - 1'b1, data_out, wr_gx,  wr_gy);

reg [11:0] rgb_in;
wire [3:0] gray_out;

grayScale grayscale(clk, rgb_in, gray_out);

//testing memory outputs to 

reg [11:0] Gx_in;
wire Gx_out;
//module memory( clk, rd_en, wr_en, wr_addr, wr_data, rd_addr, data_out);

memory Gx(clk, 1'b1, sobel_en, addr, Gx_in, addr - 1'b1, Gx_out);

initial begin
	rst = 1'b1;
	#300;
	rst =1'b0;
	#200;
	#2000;
   #50000;
	#1000;
	#50000;
	#50000;// gets to 10000_00000 
	#50000;// 1111110111
	#2000;


	#200;
	#2000;
   #50000;
	#1000;
	#50000;
	#50000;// gets to 10000_00000 
	#50000;// 1111110111
	#2000;

	#200;

	$stop;
end

always @(*) begin
	Gx_in = {wr_gx,wr_gx,wr_gx};
	rd_en = 1'b1;
	gen_en = gray_en;
	gen_done = done;
	sobel_done = done;
	rgb_in = mem;
	wr_data = {gray_out, gray_out, gray_out};

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
