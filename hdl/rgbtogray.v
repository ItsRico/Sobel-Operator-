module grayScale(clk, rgb_in, gray_out);
	//computes the grayscale image
input clk;

input [11:0] rgb_in;
output reg [3:0] gray_out;

wire [3:0]  R, G, B;

assign R = rgb_in[11:8];
assign G = rgb_in[7:4];
assign B = rgb_in[3:0];


reg [3:0] blue, green, red;
//Y(addr) = ( (0.3 * R) + (0.59 * G) + (0.11 * B) ).
//.3R ~ R>> 2 (.5 R) -> Y_r = .25R 
//.59G ~ G >> 1 (.5 G) + G >> 3 (.125) G 
//.11B ~ B >> 3

/// combinational logic that is fed input from the ROM and outputs to the RAM 
always @(*) begin

	red <= R >> 2;  //.25
	green <= ((G >> 1) + (G >> 3)); //.5 + .125
	blue <=  B >> 5; // .12
	//gray_out <= (R + B + G) / 3'd3;
	gray_out <= blue + green + red;
end


endmodule


