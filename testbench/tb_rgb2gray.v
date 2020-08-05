module TB_rgb2gray;

`timescale 10ns/10ns



reg clk;

reg [11:0] rgb_in;
wire [11:0] gray_out;


grayScale UUT(clk, rgb_in, gray_out);



initial begin

#20;
rgb_in = 12'b1111_1111_1111;
#20;


rgb_in = 12'b1010_1010_1010;

$stop;
end


always @(posedge clk) begin


clk =#10 ~ clk;

end

endmodule
