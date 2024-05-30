module controlador_frere_jacque
( output Clk_out,
  output reg Disparo,
  output reg [27:0] Temp_out,
  output reg [27:0] Freq_out,	
  input	Clk_in, Duracao, Stop_in, Play_in
);

	///clock da placa
	`define clk_FPGA 50000000 //50MHz
	//overflow para frequencias (50MHz)
	`define Fa3 22922 //698Hz (Fá3)
	`define Sol3 20408 //784Hz (Sol3)
	`define La3 18181 //880Hz (Lá3)
	`define Sib3 17167 //932Hz (Sib3)
	`define Do4 15296 //1046Hz (Dó4)
	`define Re4 13617 //1175Hz (Ré4)
	`define Fa4 11453 //1397Hz (Fá4)
	`define Sol4 10012 //1598Hz (Sol4)
	
	// overflow para tempos (50MHz)
	// BPM igual a 60 implica que t1, 1 batida, representa 1 seg
	//`define BPM 120 //batidas por minuto
	//`define BPS <= BPM / 60 //batidas por segundo
	`define ov_t4 (4 * 16000000)/(120/60)//overflow 4 batidas
	`define ov_t2 (2 * 16000000)/(120/60)//overflow 2 batidas
	`define ov_t1 16000000/(120/60)//overflow 1 batida
	`define ov_t1_2 (16000000 / 2)/(120/60)//overflow 1/2 batidas
	
	//FSM Declaração de estados 
	reg [5:0] estado, prox_estado;
	localparam s0 = 6'b000000;   //define estado 0
	localparam s1 = 6'b000001;   //define estado 1
	localparam s2 = 6'b000010;   //define estado 2
	localparam s3 = 6'b000011;   //define estado 3
	localparam s4 = 6'b000100;   //define estado 4
	localparam s5 = 6'b000101;   //define estado 5
	localparam s6 = 6'b000110;   //define estado 6
	localparam s7 = 6'b000111;   //define estado 7
	localparam s8 = 6'b001000;   //define estado 8
	localparam s9 = 6'b001001;   //define estado 9
	localparam s10 = 6'b001010;   //define estado 10
	localparam s11 = 6'b001011;   //define estado 11
	localparam s12 = 6'b001100;   //define estado 12
	localparam s13 = 6'b001101;   //define estado 13
	localparam s14 = 6'b001110;   //define estado 14
	localparam s15 = 6'b001111;   //define estado 15
	localparam s16 = 6'b010000;   //define estado 16
	localparam s17 = 6'b010001;   //define estado 17
	localparam s18 = 6'b010010;   //define estado 18
	localparam s19 = 6'b010011;   //define estado 19
	localparam s20 = 6'b010100;   //define estado 20
	localparam s21 = 6'b010101;   //define estado 21
	localparam s22 = 6'b010110;   //define estado 22
	localparam s23 = 6'b010111;   //define estado 23
	localparam s24 = 6'b011000;   //define estado 24
	localparam s25 = 6'b011001;   //define estado 25
	localparam s26 = 6'b011010;   //define estado 26
	localparam s27 = 6'b011011;   //define estado 27
	localparam s28 = 6'b011100;   //define estado 28
	localparam s29 = 6'b011101;   //define estado 29
	localparam s30 = 6'b011110;   //define estado 30
	localparam s31 = 6'b011111;   //define estado 31
	localparam s32 = 6'b100000;   //define estado 32
	localparam s33 = 6'b100001;   //define estado 33
	
	always @ (posedge Clk_in)
	begin : L1
		estado <= prox_estado;
	end
	
	always @ (*)//Combinacional 
	begin : L2
		case (estado)
			s0: if (Stop_in == 1'b1)
				 begin
					prox_estado <= s0;
				 end
				 else
				 begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s1;
					else prox_estado <= s0;
				end
			s1: if (Stop_in == 1'b1)
				 begin
					prox_estado <= s0;
				 end
				 else
				 begin 
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s2;
					else prox_estado <= s1;
				 end
			s2: if (Stop_in == 1'b1)
				 begin
					prox_estado <= s0;
				 end
				 else
				 begin
					if (Duracao == 1'b0 && Play_in == 1'b1) 
						prox_estado <= s3;
					else prox_estado <= s2;
				 end
			s3:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1) 
						prox_estado <= s4;
					else prox_estado <= s3;
				end
			s4:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s5;
					else prox_estado <= s4;
				end
			s5:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1) 
						prox_estado <= s6;
					else prox_estado <= s5;
				end
			s6:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1) 
						prox_estado <= s7;
					else prox_estado <= s6;
				end
			s7:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1) 
						prox_estado <= s8;
					else prox_estado <= s7;
				end
			s8:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end 
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s9;
					else prox_estado <= s8;
				end
			s9:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s10;
					else prox_estado <= s9;
				end
			s10:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s11;
					else prox_estado <= s10;
				end
			s11:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s12;
					else prox_estado <= s11;
				end
			s12:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s13;
					else prox_estado <= s12;
				end
			s13:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s14;
					else prox_estado <= s13;
				end
			s14:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s15;
					else prox_estado <= s14;
				end
			s15:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end 
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s16;
					else prox_estado <= s15;
				end
			s16:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s17;
					else prox_estado <= s16;
				end
			s17:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s18;
					else prox_estado <= s17;
				end
			s18:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end 
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s19;
					else prox_estado <= s18;
				end
			s19:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s20;
					else prox_estado <= s19;
				end
			s20:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end 
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s21;
					else prox_estado <= s20;
				end
			s21:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end 
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s22;
					else prox_estado <= s21;
				end
			s22:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s23;
					else prox_estado <= s22;
				end
			s23:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s24;
					else prox_estado <= s23;
				end
			s24:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s25;
					else prox_estado <= s24;
				end
			s25:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s26;
					else prox_estado <= s25;
				end
			s26:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s27;
					else prox_estado <= s26;
				end
			s27:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s28;
					else prox_estado <= s27;
				end
			s28:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s29;
					else prox_estado <= s28;
				end
			s29:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s30;
					else prox_estado <= s29;
				end
			s30:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s31;
					else prox_estado <= s30;
				end
			s31:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s32;
					else prox_estado <= s31;
				end
			s32:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s33;
					else prox_estado <= s32;
				end
			s33:if (Stop_in == 1'b1)
				begin
					prox_estado <= s0;
				end
				else
				begin
					if (Duracao == 1'b0 && Play_in == 1'b1)
						prox_estado <= s1;
					else prox_estado <= s33;
				end
			default: prox_estado <= s0; //recupera de estado inválido
		endcase
	end	
	
	//FSM Lógica para controle das saídas
	always @ (estado)//Combinacional 
	begin : L3
		case (estado) //s0 apenas inicia a prox nota
			s0: nota(0,`ov_t1); //s0 apenas inicia a prox nota
			s1: nota(`Fa3, `ov_t1); 
			s2: nota(`Sol3, `ov_t1);
			s3: nota(`La3, `ov_t1);
			s4: nota(`Fa3, `ov_t1);
			s5: nota(`Fa3, `ov_t1);
			s6: nota(`Sol3, `ov_t1);
			s7: nota(`La3, `ov_t1);
			s8: nota(`Fa3, `ov_t1);
			s9: nota(`La3, `ov_t1);
			s10: nota(`Sib3, `ov_t1);
			s11: nota(`Do4, `ov_t2);
			s12: nota(`La3, `ov_t1);
			s13: nota(`Sib3, `ov_t1);
			s14: nota(`Do4, `ov_t2);
			s15: nota(`Do4, `ov_t1_2);
			s16: nota(`Re4, `ov_t1_2);
			s17: nota(`Do4, `ov_t1_2);
			s18: nota(`Sib3, `ov_t1_2);
			s19: nota(`La3, `ov_t1);
			s20: nota(`Fa3, `ov_t1);
			s21: nota(`Do4, `ov_t1_2);
			s22: nota(`Re4, `ov_t1_2);
			s23: nota(`Do4, `ov_t1_2);
			s24: nota(`Sib3, `ov_t1_2);
			s25: nota(`La3, `ov_t1);
			s26: nota(`Fa3, `ov_t1);
			s27: nota(`Sol4, `ov_t1);
			s28: nota(`Do4, `ov_t1);
			s29: nota(`Fa4, `ov_t2);
			s30: nota(`Sol4, `ov_t1);
			s31: nota(`Do4, `ov_t1);
			s32: nota(`Fa4, `ov_t2);
			s33: nota(0, `ov_t4);
		endcase
	end
	
	
	//Atribuição contínua
	assign Clk_out = Duracao & Clk_in;	
	
	//Tarefa para atribuição de saídas nos estados
	task nota( input [27:0] ov_f, ov_t);
	begin
		Temp_out = ov_t; //define a duração	proxima nota			
		Freq_out = ov_f; //define a frequência nota atual
		Disparo = 1'b1;  //dispara o temp a próxima nota		
	end
	endtask
	
endmodule		