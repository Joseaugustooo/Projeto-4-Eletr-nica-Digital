module controlador_teste
(
	output Clk_out = 1'b0,
	output reg Disparo = 1'b0, 
	output reg [27:0] Temp_out,
	output reg [27:0] Freq_out,	
	input Clk_in, Duracao	
);
	//overflow para frequencias
	`define C4 47802 //1046Hz (C4 ou Dó4)
	`define D4 42553 //1175Hz (D4 ou Ré4)
	`define E4 37937 //1318Hz (E4 ou Mi4)
	`define F4 35791 //1397Hz (F4 ou Fá4)
	`define G4 31290 //1598Hz (G4 ou Sol4)
	
	//overflow para tempos
	`define ov_t1 200000000 //4000ms
	`define ov_t2 100000000 //2000ms
	`define ov_t3 50000000 //1000ms
	`define ov_t4 25000000 //500ms
	`define ov_t5 12500000 //250ms
	
	//FSM Declaração de estados 
	reg [4:0] estado, prox_estado;	
	localparam s0 = 2'b00;   //define estado 0
	localparam s1 = 2'b01;   //define estado 1
	localparam s2 = 2'b11;   //define estado 2
	localparam s3 = 2'b10;   //define estado 3
	
	//FSM Lógica para controle do estado atual
	always @ (posedge Clk_in)
	begin : L1
		estado <= prox_estado;
	end
	
	//FSM Lógica para controle do próximo estado
	always @ (posedge Clk_in)//Combinacional 
	begin : L2
		case (estado)
			s0: if (!Duracao) prox_estado <= s1;//próximo estado	
			s1: if (!Duracao) prox_estado <= s2;//próximo estado
			s2: if (!Duracao) prox_estado <= s3;//próximo estado	
			s3: if (!Duracao) prox_estado <= s1;//próximo estado
			default: prox_estado <= s0; //recupera de estado inválido
		endcase
	end	
	
	//FSM Lógica para controle das saídas
	always @ (estado)//Combinacional 
	begin : L3
		case (estado) //s0 apenas inicia a prox nota
			s0: nota(0,`ov_t4);  //freq atual, dur prox		
			s1: nota(`C4,`ov_t4);//freq atual, dur prox
			s2: nota(`E4,`ov_t4);//freq atual, dur prox
			s3: nota(`G4,`ov_t4);//freq atual, dur prox		
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
		
