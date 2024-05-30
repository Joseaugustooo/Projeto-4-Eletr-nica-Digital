module selbuzzer (
	input clk,m1,m2,sel,mute,
	output buzzer
);
	assign buzzer = ((m1 & ~sel) | (m2 & sel)) & mute;
endmodule
