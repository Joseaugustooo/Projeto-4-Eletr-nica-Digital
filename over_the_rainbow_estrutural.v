module over_the_rainbow_estrutural (
	input clock,c16, stop, play, sel,
	output buzzer
);

	wire t1, t2, t4;
	reg t = 0;
	reg tt;
	reg play_reg,stop_reg;
	wire [27:0] t3,t5;
	reg [1:0]states;
	localparam s0 = 2'b00;
	localparam s1 = 2'b01;
	localparam s2 = 2'b10;
	
	temporizador 	temp( .Q(t1),
								.Clk(c16),
								.Disparo(t2),
								.Overflow(t3)
						);
						
	divisor_clock 	div_clk( .Clk_out(buzzer),
									.Clk_in(t4),
									.Overflow(t5)
						);
	
	controlador_over_the_rainbow 	control( .Clk_out(t4),
									.Disparo(t2),
									.Temp_out(t3),
									.Freq_out(t5),
									.Clk_in(c16),
									.Duracao(t1),
									.Stop_in(stop_reg),
									.Play_in(play_reg)
						);
				
	always @ (posedge clock)
	begin
		if (tt == 1'b1)
		begin
			t <= ~t;
		end
		//IF (sel = '1') THEN 
//		if(t == 1'b0)
//		begin
//			tt <= play;
//		end
//		else
//		begin
//			tt <= play | stop;
//		end
		case(states)
			s0:
				if(sel == 1'b0)
				begin
					if(play == 1'b1)
					begin
						states <= s1;
					end
				end
			s1:
				if(stop == 1'b1)
				begin
					states <= s0;
				end
				else if(play == 1'b1)
				begin
					states <= s2;
				end
			s2:
				if(stop == 1'b1)
				begin
					states <= s0;
				end
				else if(play == 1'b1)
				begin
					states <= s1;
				end
		endcase
		
		case(states)
			s0:
			begin
				stop_reg <= 1'b1;
				play_reg <= 1'b0;
			end
			s1:
			begin
				stop_reg <= 1'b0;
				play_reg <= 1'b1;
			end
			s2:
			begin
				stop_reg <= 1'b0;
				play_reg <= 1'b0;
			end
			default:
			begin
				stop_reg <= 1'b1;
				play_reg <= 1'b0;
			end
		endcase
	end				
	
endmodule
