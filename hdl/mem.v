module memOp( clk, wr_en,rd_en, sobel_en, wr_addr, wr_data, rd_addr, data_out, wr_gx,  wr_gy, sobel_done);

input clk,wr_en, rd_en;

input sobel_en;
input [9:0] wr_addr; 
input [11:0] wr_data;
input [9:0] rd_addr;
output reg [11:0] data_out;
output reg  [3:0] wr_gx;
output reg [3:0] wr_gy;
output reg  sobel_done;


/* synthesis preserve */
reg [11:0] mem [0:1023] ;	
						//	         168421  
localparam thirty4 = 10'b0000_100010;
localparam thirty3 = 10'b0000_100001;
localparam thirty2 = 10'b0000_100000;
localparam thirty1 = 10'b00000_11111;
//convolution kernel for applying sobel
// we need 9 adjacent values -> output 1 pixel value

//our horizontal kernel
//reg signed x11 = 1;
//reg signed x12 = 0;
//reg signed x13 = -1;
//reg signed x21	= 2;
//reg signed x22	= 0;
//reg signed x23 = -2;
//reg signed x31 = 1;
//reg signed x32 = 0;
//reg signed x33 = -1;
 
//
//our vertical kernel
//todo
reg lock; 
 reg signed [5:0] x1, x2, x3,y1, y2, y3, temp,temp2;
 reg signed [5:0] a11, a12, a13, a21, a22, a23, a31, a32, a33;
reg [9:0] a11_addr,a12_addr, a21_addr,a23_addr  ,a13_addr, a31_addr, a32_addr, a33_addr, count_c, count;
always @(posedge clk) begin
	count = count_c;
end

always @( posedge clk ) begin
	if(count_c == 10'b11111_11111  & sobel_en == 1'b1) begin
			sobel_done = 1'b1;
		end
		else begin
			lock = 1'b0;
			sobel_done = 1'b0;
		end
		
					///n = 32, dimensions of photo
		if(sobel_en == 1'b1 ) begin
				count_c = count + 10'b00000_00001;
				if( rd_addr < thirty2) begin
					wr_gx = 4'b0000;//mem[rd_addr];
					wr_gy = 4'b0000;
	
				end else if( rd_addr > 1024 - thirty2) begin
					wr_gx = 4'b0000;//mem[rd_addr];
					wr_gy = 4'b0000;

				end else if(rd_addr % thirty1 ==  1 | rd_addr % thirty2 == 0) begin
					wr_gx = 4'b0000;
					wr_gy = 4'b0000;
				end else begin
							/// a11 				-	a31    +		//2*a12 		- 2* a32       +           	//a13 - a33
					a11_addr = rd_addr - thirty3;
					a12_addr = rd_addr - thirty2;
					a21_addr = rd_addr - 10'b00000_00001;
					a23_addr = rd_addr + 10'b00000_00001;

					a13_addr = rd_addr - thirty1;
					a31_addr = rd_addr + thirty1 ; 
					a32_addr = rd_addr + thirty2;
					a33_addr = rd_addr + thirty3;
					
					
					a11 = {2'b00, mem[a11_addr][3:0]};
					a12 = {2'b00, mem[a12_addr][3:0]};
					a13 = {2'b00, mem[a13_addr][3:0]};	
					a21 = {2'b00, mem[a21_addr][3:0]};
					a23 = {2'b00, mem[a23_addr][3:0]};
					a31 = {2'b00, mem[a31_addr][3:0]};
					a32 = {2'b00, mem[a32_addr][3:0]};
					a33 = {2'b00, mem[a33_addr][3:0]};
				
					x1 = {a11[5], a11} - {a31[5], a31};
					x2 = ({a12[5], a12} - {a32[5], a32}) << 1;
					x3 = {a13[5], a13} - {a33[5], a33};
					y1 = {a13[5], a13} - {a11[5], a11};
					y2 = ({a23[5], a23} - {a21[5], a21}) << 1;
					y3 = {a33[5], a33} - {a31[5], a31};
					
					temp = {x1[5], x1}  + {x2[5], x2} + {x3[5], x3};
					temp2 = {y1[5], y1}  + {y2[5], y2} + {y3[5], y3};

					if(temp > 6'b001111 & temp[5] == 1'b0) begin
						wr_gx = 4'b1111;
					end 
					else if( temp[5] == 1'b1) begin
						wr_gx = 4'b0000;
					end else begin
						wr_gx = {x1[5], x1}  + {x2[5], x2} + {x3[5], x3};

					end
		
					if(temp2 > 6'b001111 & temp2[5] == 1'b0) begin
						wr_gy = 4'b1111;
					end 
					else if( temp2[5] == 1'b1) begin
						wr_gy = 4'b0000;
					end else begin
						wr_gy = {x1[5], x1}  + {x2[5], x2} + {x3[5], x3};

					end
				//wr_gy = (mem[rd_addr -thirty1]- mem[rd_addr - thirty3])
			//	+ (2* mem[rd_addr - 10'b00000_00001] - 2*mem[rd_addr + 10'b00000_00001]) 
			//	+ (mem[rd_addr + thirty3] - mem[rd_addr - thirty1]); 

			end
		end/// if we are not using the operator, set to 0 to keep quartus from inferring
		else begin
			wr_gx = 4'b0000;
			wr_gy = 4'b0000;
		end
end

///if at boundary, use 0 padding

//for each pixel at addr_gen, computer horizontal and vertical outputs


//for each output, clamp outputs to 0 if < 0 , saturate to 255 if > 255

// if at end, assert sobel_done high


/// 1 1 1  1 1 1 1  1 1 
// 1
// 1
// 1

always @(posedge clk) begin

	if( wr_en == 1'b1) begin
		mem[wr_addr] <= wr_data;  // wr_addr 0 - 3 
	end
	if( rd_en == 1'b1) begin
		data_out = mem[rd_addr];
	end
end

//assign data_out = mem[rd_addr];


endmodule
