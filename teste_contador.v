module teste_contador(
	input clk,decimo,uni_segundo,dec_segundo,minuto,
	output reg [4:1] display,
	output reg numero
);
	reg [1:0] states;
	localparam s0 = 2'b00;
	localparam s1 = 2'b01;
	localparam s2 = 2'b10;
	localparam s3 = 2'b11;
	wire div;
	reg dis = 1'b1;
	reg num;
	temporizador 	temp( .Q(div),
								.Clk(clk),
								.Disparo(dis),
								.Overflow(50000)
						);
	always @ (clk)
	begin : L1
		case(states)
			s0: 
			if (div == 1'b0)
			begin
				states <= s1;
			end
			else
			begin
				states <= s0;
			end
			s1: 
			if (div == 1'b0)
			begin
				states <= s2;
			end
			else
			begin
				states <= s1;
			end
			s2: 
			if (div == 1'b0)
			begin
				states <= s3;
			end
			else
			begin
				states <= s2;
			end
			s3: 
			if (div == 1'b0)
			begin
				states <= s0;
			end
			else
			begin
				states <= s3;
			end
		endcase
		case (states)
			s0:
			begin
				display = 4'b1110;
				num <= decimo;
			end
			s1:
			begin
				display = 4'b1101;
				num <= uni_segundo;
			end
			s2:
			begin
				display = 4'b1011;
				num <= dec_segundo;
			end
			s3:
			begin
				display = 4'b0111;
				num <= minuto;
			end
		endcase
		numero = num;
	end
						
endmodule
