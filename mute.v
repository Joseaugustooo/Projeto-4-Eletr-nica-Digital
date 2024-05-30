module mute (
	input clk,mute,
	output buzzer
);
	assign buzzer = (mute & clk);
endmodule
