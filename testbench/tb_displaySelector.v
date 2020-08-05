module tb_DISPS;

//wr address is always addr from address gen
//read address can either be Q_addr
// or Vga Addr, depending on if the operator has finished
reg clk, rst, SW0;

reg gen_done, sobel_done2; 
wire gray_en, sobel_en;

wire [5:0] state;

FSM fsm(clk, rst , SW0,  gen_done,sobel_done2, gray_en, sobel_en, state);

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

//
ROM rom( 1'b1, addr, red, green, blue, mem);


reg [2:0] SW;

reg en_ram;
reg en_sobel; //new

reg [9:0] vga_addr;

reg [5:0] cur_state;
reg [11:0] mem_out;
reg [11:0] Gxx;
reg [11:0] Gyy;
reg [3:0] r, g, b;
wire [3:0] rVGA, bVGA, gVGA;
wire [9:0] Q_addr;


displaySelector DS(clk, SW, en_ram, en_sobel, addr, vga_addr, mem_out, Gxx, Gyy, state, red, green, blue, rVGA, bVGA, gVGA, Q_addr);

reg wr_en, rd_en;

reg [9:0] wr_addr; 
reg [11:0] wr_data;
reg [9:0] rd_addr;
wire [11:0] data_out;
wire [3:0] wr_gx;
wire [3:0] wr_gy;
wire sobel_done;

memOp Gray( clk, gray_en,rd_en, sobel_en, addr, wr_data, Q_addr, data_out, wr_gx,  wr_gy, sobel_done);

reg [11:0] rgb_in;
wire [3:0] gray_out;

grayScale grayscale(clk, rgb_in, gray_out);

//testing memory outputs to 

reg [11:0] Gx_in;
wire [11:0] Gx_out;

memory Gx(clk, 1'b1, sobel_en, addr, Gx_in, Q_addr, Gx_out);

reg [11:0] Gy_in;
wire [11:0] Gy_out;
//module memory( clk, rd_en, wr_en, wr_addr, wr_data, rd_addr, data_out);

memory Gy(clk, 1'b1, sobel_en, addr, Gy_in, Q_addr, Gy_out);

always @(*) begin
	mem_out = data_out;
   Gxx = Gx_out;
   Gyy = Gy_out;
	r = red;
	b = blue;
	g = green;
	Gx_in = {wr_gx,wr_gx,wr_gx};
	Gy_in = {wr_gx,wr_gx,wr_gx};
	rd_en = 1'b1;
	gen_en = gray_en;
	gen_done = done;
	sobel_done2 = sobel_done;
	rgb_in = mem;
	rd_addr = Q_addr;
	wr_data = {gray_out, gray_out, gray_out};

end

initial begin
	rst = 1'b1;
	#300;
	vga_addr = 10'b0000110000;
	rst =1'b0;
	#200;
	#2000;
   #50000;
	#1000;
	#50000;
	#50000;// gets to 10000_00000 
	#50000;// 1111110111
	#2000;

	rst = 1'b0;
	#200;
	SW0 = 1'b1;
	#200;
	#2000;
   #50000;
	#1000;
	#50000;
	#50000;// gets to 10000_00000 
	#50000;// 1111110111
	#2000;
	SW0 = 1'b0;

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
