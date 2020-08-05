module tb_top;

/*
wire [31:0]    col, row;
wire [3:0]     red, green, blue, gray_out;

// Timing signals - don't touch these.
wire           h_sync, v_sync;
wire           disp_ena;
wire           vga_clk;
wire wr_en, gen_done;

wire gray_en, w_en2, w_en3;
wire [3:0] rVGA, gVGA, bVGA;
wire [5:0] current_state;
wire rst;
wire [11:0] mem;
wire  [11:0] wr_data;
wire [11:0] data_out;

wire [9:0]  wr_addr, gen_addr;
reg  [9:0] 	mem_addr, rom_addr;

ROM toDisplay({row[4:0], col[4:0]}, red, green, blue, mem);
memory u3(vga_clk, wr_en, wr_addr, wr_data, mem_addr, data_out);
addressGen u2(vga_clk, rst, gray_en, gen_addr, gen_done);
grayScale gray(vga_clk, mem, gray_out) ;

FSM u1(vga_clk, rst, SW, gray_en, w_en2, w_en3, LEDR, current_state);

displaySelector uu4(vga_clk, rst, SW,gen_addr,data_out, gray_en, gen_done,
						wr_en, gray_out, red, green, blue, rVGA, bVGA, gVGA, wr_data);


assign wr_addr = gen_addr; //connected to the address from address gen
*/
endmodule
