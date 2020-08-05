module pulsegen(clk, reset, go_out);

	input clk, reset;
	output go_out;
	reg go_out;
	reg [18:0] count;
	reg [18:0] count_c;
	reg go;
	reg [18:0] divideby;
	
	//DFF
	always@(posedge clk) begin
			count <= #1 count_c;
			go_out <= go;
	end
	
	always@(*) begin
		
		count_c = count; //default halt
		go = 1'b0;
		divideby = 19'b111_1010_0001_0010_0000;
		
		if (count != (divideby-1'b1)) begin
			count_c = count + 1'b1;
		end
		
		if (count == (divideby-1'b1)) begin
			count_c = 19'b000_0000_0000_0000_0000;
		end
		
		if (count == 6'b00_0000) begin
			go = 1'b1;
		end

		
		if (divideby == 19'b000_0000_0000_0000_0000) begin
			count_c = 19'b000_0000_0000_0000_0000;
			go = 1'b0;
		end
		
		if (reset == 1'b1) begin
			count_c = 19'b000_0000_0000_0000_0000;
		end
	end
	
endmodule
