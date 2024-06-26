module divisor_clock_16_MHz 
(
	output reg Clk_out = 1'b0,
	input Clk_in
);
	reg [27:0] cnt = 0;
	reg Overflow = 2;
	
	always @(posedge Clk_in)	 
	begin
		if (cnt < Overflow) begin
			cnt <= cnt + 1'b1;			
			Clk_out <= Clk_out;
		end
		else begin
			cnt <= 0;
			Clk_out <= ~Clk_out;
		end
	end

endmodule
