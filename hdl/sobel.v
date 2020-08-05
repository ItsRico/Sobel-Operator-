module Sobel(clk, rst, sobel_en, gray_in, gen_addr, Gx, Gy, sobel_done);
//convolution kernel for applying sobel
// we need 9 adjacent values -> output 1 pixel value
input clk, rst, sobel_en;

input [3:0] gray_in; //all the values of the ram share the same luminance Y value
input [9:0] gen_addr; //address at which the kernel is to begin processing and writing to
output [3:0] Gx;
output [3:0] Gy;
output sobel_done;
//our horizontal kernel
reg signed x11 = 1;
reg signed x12 = 0;
reg signed x13 = -1;
//
//our vertical kernel

//





///if at boundary, use 0 padding

//for each pixel at addr_gen, computer horizontal and vertical outputs


//for each output, clamp outputs to 0 if < 0 , saturate to 255 if > 255

// if at end, assert sobel_done high
endmodule
