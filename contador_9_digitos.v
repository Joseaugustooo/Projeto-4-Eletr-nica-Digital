module contador_9_digitos
(
	input clk,play,stop,
	output reg milesimo,centesimo,decimo,uni_segundo,dec_segundo,uni_minuto,dec_minuto,uni_hora,dec_hora
);
	reg [1:0] states;
	localparam s0 = 2'b00;
	localparam s1 = 2'b01;
	localparam s2 = 2'b10;
	wire div;
	reg mili,cent,dec,useg,dseg,umin,dmin,uhora,dhora;
	reg dis = 1'b1;
	temporizador 	temp( .Q(div),
								.Clk(clk),
								.Disparo(dis),
								.Overflow(5)
						);
			
	always @ (clk)
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
				mili = 0;
				cent = 0;
				dec = 0;
				useg = 0;
				dseg = 0;
				umin = 0;
				dmin = 0;
				uhora = 0;
				dhora = 0;
			end
			s1:
			begin
				if(div == 1'b0)
				begin
					if (mili < 9)
					begin
						mili = mili+1;
					end
					else if (cent < 9)
					begin
						mili = 0;
						cent = cent+1;
					end
					else if (dec < 9)
					begin
						mili = 0;
						cent = 0;
						dec = dec+1;
					end
					else if (useg < 9)
					begin
						mili = 0;
						cent = 0;
						dec = 0;
						useg = useg+1;
					end
					else if (dseg < 5)
					begin
						mili = 0;
						cent = 0;
						dec = 0;
						useg = 0;
						dseg = dseg+1;
					end
					else if (umin < 9)
					begin
						mili = 0;
						cent = 0;
						dec = 0;
						useg = 0;
						dseg = 0;
						umin = umin+1;
					end
					else if (dmin < 5)
					begin
						mili = 0;
						cent = 0;
						dec = 0;
						useg = 0;
						dseg = 0;
						umin = 0;
						dmin = dmin+1;
					end
					else if (uhora < 9)
					begin
						mili = 0;
						cent = 0;
						dec = 0;
						useg = 0;
						dseg = 0;
						umin = 0;
						dmin = 0;
						uhora = uhora + 1;
					end
					else if (dhora < 9)
					begin
						mili = 0;
						cent = 0;
						dec = 0;
						useg = 0;
						dseg = 0;
						umin = 0;
						dmin = 0;
						uhora = 0;
						dhora = dhora + 1;
					end
					else
					begin
						mili = 0;
						cent = 0;
						dec = 0;
						useg = 0;
						dseg = 0;
						umin = 0;
						dmin = 0;
						uhora = 0;
						dhora = 0;;
					end
				end
			end
			s2:
			begin
				mili = mili;
				cent = cent;
				dec = dec;
				useg = useg;
				dseg = dseg;
				umin = umin;
				dmin = dmin;
				uhora = uhora;
				dhora = dhora;
			end
		endcase
		milesimo = mili;
		centesimo = cent;
      decimo = dec;
		uni_segundo = useg;
		dec_segundo = dseg;
		uni_minuto = umin;
		dec_minuto = dmin;
		uni_hora = uhora;
		dec_hora = dhora;
		
    end
endmodule			
			
			
			