module tb_genDone;


reg clk, rst, gen_en,sobel_en2;
wire [9:0] addr;
wire done;

reg [9:0] c_addr;

//module addressGen(clk, rst, gen_en, sobel_en, addr, done);

addressGen ADDGEN(clk, rst, gen_en, sobel_en2, addr, done);




reg gen_done, sobel_done; 
wire gray_en, sobel_en;

wire [5:0] state;

FSM fsm(clk, rst , gen_done,sobel_done, gray_en, sobel_en, state);



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

	#600
	$stop;
end

always @(*) begin
	sobel_en2 = sobel_en;
	gen_done = done;
	gen_en = gray_en;
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
