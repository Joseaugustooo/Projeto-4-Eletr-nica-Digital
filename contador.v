module contador(
	input clk,play,stop,
	output [4:1] decimo,uni_segundo,dec_segundo,minuto
);
	reg [1:0] states;
	localparam s0 = 2'b00;
	localparam s1 = 2'b01;
	localparam s2 = 2'b10;
	wire div;
	reg [4:1] dec,useg,dseg,min;
	reg dis = 1'b1;
	temporizador 	temp( .Q(div),
								.Clk(clk),
								.Disparo(dis),
								.Overflow(5000000)
						);
			
	always @(posedge clk)
	begin : L1
		case(states)
			s0:
				if(play == 1'b1)
				begin
					states <= s1;
				end
				else
				begin
					states <= s0;
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
			default: states <= s0;
		endcase

		case(states)
			s0:
			begin
				dec <= 0;
				useg <= 0;
				dseg <= 0;
				min <= 0;
			end
			s1:
			begin
				if(div == 1'b0)
				begin
					if (dec < 9)
					begin
						dec <= dec+1;
					end
					else if (useg < 9)
					begin
						dec <= 0;
						useg <= useg+1;
					end
					else if (dseg < 5)
					begin
						dec <= 0;
						useg <= 0;
						dseg <= dseg+1;
					end
					else if (min < 9)
					begin
						dec <= 0;
						useg <= 0;
						dseg <= 0;
						min <= min+1;
					end
					else
					begin
						dec <= 0;
						useg <= 0;
						dseg <= 0;
						min <= 0;
					end
				end
			end
			s2:
			begin
				dec <= dec;
				useg <= useg;
				dseg <= dseg;
				min <= min;
			end
		endcase
    end
	 
	   assign decimo = dec;
		assign uni_segundo = useg;
		assign dec_segundo = dseg;
		assign minuto = min;
endmodule			
			
			
			