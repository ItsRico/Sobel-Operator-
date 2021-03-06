module tb_SobeltoMem;


reg clk, rst, gen_en, sobel_en3;
wire [9:0] addr;
wire done;



addressGen UUT(clk, rst, gen_en, sobel_en3, addr, done);

reg [9:0] addr_rd;
wire [11:0] mem;
wire [3:0] red;
wire [3:0] green;
wire [3:0] blue;


ROM rommem( addr_rd, red, green, blue, mem);



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

//////////
reg [11:0] rgb_in;
wire [3:0] gray_out;


grayScale gray(clk, rgb_in, gray_out);


reg  SW;
reg gen_done, sobel_done2; 
wire gray_en, sobel_en, w_en3;

wire [5:0] state;


//module FSM(clk, rst, SW , gen_done,sobel_done, gray_en, sobel_en, w_en3, state);

FSM fssm(clk, rst, SW , gen_done,sobel_done2, gray_en, sobel_en, w_en3, state);

reg [2:0] SW2;
reg en_ram;
reg en_sobel;
reg gray_en2;
reg sobel_en4;
reg [9:0] gen_addr;
reg [9:0] vga_addr;
reg [11:0] ram; //data stored in RAM
reg [11:0] Gx_out;
reg [11:0] Gy_out;
reg [3:0] r, b, g;
wire [3:0] rVGA, bVGA, gVGA;
wire [9:0] Q_addr;
// displaySelector(clk, rst, SW, en_ram, gray_en, sobel_en, gen_addr, vga_addr, data_out, red, green, blue, rVGA, bVGA, gVGA, rd_addr);

displaySelector disp(clk, rst, SW2, en_ram, en_sobel, gen_en,sobel_en4, gen_addr, vga_addr, ram, Gx_out, Gy_out,  r, g, b, rVGA, bVGA, gVGA, Q_addr);


reg  wr_en4;
reg [9:0] wr_addr2; 
reg [11:0] wr_data2;
reg [9:0] rd_addr2;

wire [11:0] Gx;

memory Gxx( clk, wr_en4, wr_addr2, wr_data2, rd_addr2, Gx);



reg  wr_en5;
reg [9:0] wr_addr3; 
reg [11:0] wr_data3;
reg [9:0] rd_addr3;

wire [11:0] Gy;

memory Gyy( clk, wr_en5, wr_addr3, wr_data3, rd_addr3, Gy);
initial begin
	rst = 1'b1;
	#300;
	rst =1'b0;
	#200;
	SW = 1'b1;
	#2000;
   #50000;
	#1000;
	#50000;
	#50000;// gets to 10000_00000 
	#50000;// 1111110111
	#2000;
	SW = 1'b0;
	en_ram = 1'b0;
	#400;
	SW = 1'b1;
	
	#2000;
	#50000;
	#1000;
	#50000;
	#50000;// gets to 10000_00000 
	#50000;// 1111110111
	#2000;
	
	#500;
	
	$stop;
end

always @(*) begin
	r = red;
	g = green;
	b = blue;
	vga_addr = 10'b00001_1000;
	gen_addr = addr;
	gen_en = gray_en;
	
	ram = data_out;
	sobel_en2 = sobel_en;
	sobel_en3 = sobel_en;
	sobel_en4 = sobel_en;
	sobel_done2 = done;
	gen_done = done;
	
	addr_rd = Q_addr;
	rd_addr = Q_addr;
	rd_addr2 = Q_addr;
	rd_addr3 = Q_addr;
	
	wr_addr = addr;
	wr_addr2 = addr;
	wr_addr3 = addr;
	rgb_in = mem;
	
	wr_data = {gray_out, gray_out, gray_out};
	wr_data2 = {wr_gx,wr_gx,wr_gx};
	wr_data3 = {wr_gy,wr_gy,wr_gy};
	Gx_out =  Gx; 
	Gy_out =  Gy;
	wr_en2 = gen_en;
	wr_en4 = sobel_en;
	wr_en5 = sobel_en;
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
