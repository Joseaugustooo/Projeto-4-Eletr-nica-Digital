/*
Autor: Malki-çedheq Benjamim
Disciplina: Eletrônica Digital 1A
Descrição: Modulo para geração de pixel para interface VGA
Referência: 
	https://web.mit.edu/6.361/www/labkit/vga.shtml
	http://tinyvga.com/vga-timing/640x480@60Hz

Detalhamento:

	O módulo `pixel_generator` é uma parte crucial da interface VGA, responsável por gerar os sinais de cor que serão enviados para o monitor ou tela. Ele cria diferentes padrões de cores e imagens na tela, baseados em contadores de varredura vertical e horizontal, bem como nas chaves de entrada `key`.
	
	1. **Entradas:**
		- `clock`: O sinal de clock do sistema.
		- `dat_act_h`: Sinal de ativação de pixels horizontal (vem do módulo de sincronização horizontal).
		- `dat_act_v`: Sinal de ativação de pixels vertical (vem do módulo de sincronização vertical).
		- `hcount`: Contador de varredura horizontal (número da coluna atual).
		- `vcount`: Contador de varredura vertical (número da linha atual).
		- `key`: Chaves de entrada que definem o padrão de cores a ser exibido.
		
	2. **Saídas:**
		- `vga_r`, `vga_g`, `vga_b`: Sinais de cores vermelha, verde e azul, respectivamente, que serão enviados para o monitor.
		
	3. **Variáveis e Sinais Internos:**
		- `disp_RGB`: Sinal interno para armazenar os valores das cores a serem enviados para o monitor.
		- `data`: Registrador para armazenar os dados das cores a serem exibidas.
		- `h_dat` e `v_dat`: Registradores para controlar as cores das barras horizontais e verticais.
		- `dat_cruz` e `dat_char`: Registradores para controlar cores específicas em posições específicas da tela.
		- `vga_clk`: Sinal de clock interno para sincronização.
		
	4. **Constantes de Cores:**
		- Definem as constantes para as diferentes cores, como preto, vermelho, verde, etc.
		
	5. **Lógica de Geração de Clock Interno:**
		- Gera um sinal de clock interno `vga_clk` com uma frequência de 25 MHz para sincronização.
		
	6. **Lógica de Saída VGA:**
		- Os sinais `dat_act_h` e `dat_act_v` são usados para ativar os pixels apenas quando a varredura horizontal e vertical estiver ocorrendo.
		- O sinal `disp_RGB` é preenchido com os valores de cor apropriados com base nos padrões e posições.
		- Os sinais de cores `vga_r`, `vga_g` e `vga_b` são definidos de acordo com os valores presentes em `disp_RGB`.
		
	7. **Lógica de Geração de Cores:**
		- Diferentes lógicas são implementadas para gerar cores em diferentes partes da tela com base nos contadores de varredura horizontal e vertical.
		- Padrões de cores incluem barras de cores horizontais e verticais, um tabuleiro colorido e cruzes.

O módulo `pixel_generator` é fundamental para criar as imagens e cores na tela VGA, e suas saídas são as cores que serão exibidas no monitor. A combinação dessas saídas cria diferentes padrões visuais e imagens na tela.
*/
module pixel_generator(
   clock,   
	dat_act_h,
	dat_act_v,
	hcount,
   vcount,
	//key,
	sel,
   vga_r, vga_g, vga_b   
);
	input clock;     	//50MHz clock de entrada do sistema
	input dat_act_h;		//flag auxiliar para ativação de pixels (horizontal)
	input dat_act_v;		//flag auxiliar para ativação de pixels (vertical)
	input [9:0] hcount;	//valor do contador de varredura horizontal
	input [9:0] vcount;	//valor do contador de varredura vertical
	//input  [2:1] key;  	//conexão com chaves/botes da placa
	input sel;
	output vga_r, vga_g, vga_b;    //Saída de dados VGA

	wire [2:0] disp_RGB; //net para condução dos dados VGA a saída RGB

	reg [2:0] data;      //registrador para dados VGA
	reg [2:0] h_dat;     //registrador para posição horizontal
	reg [2:0] v_dat;     //registrador para posição vertical
	reg [2:0] dat_draw;  //registrador para ...

	wire  dat_act;			//condução para ativação dos pixels
	reg   vga_clk; 	   //clock do VGA

	// CONSTANTES: Cores
	localparam BLACK 	= 3'h0; 	// Preto
	localparam RED   	= 3'h1; 	// Vermelho
	localparam GREEN 	= 3'h2; 	// Verde
	localparam YELLOW	= 3'h3; 	// Amarelo
	localparam BLUE	= 3'h4; 	// Azul
	localparam MAGENTA= 3'h5;  // Magenta
	localparam CYAN  	= 3'h6;  // Ciano
	localparam WHITE 	= 3'h7; 	// Branco
	
	// CONSTANTES: Central da tela
	localparam CENTER_X = 455;
	localparam CENTER_Y = 283;
	
	
	// CONSTANTES: Dimensão de caracteres
	localparam CHAR_WIDTH = 2;
	localparam CHAR_HEIGHT = 3;

   //******************Geração de clock interno***********************
	always @(posedge clock)
	begin
		vga_clk = ~vga_clk;
	end
	//--------------------------------------------

	//************************VGA saídas*******************************
	// atribuição dos sinais às respectivas saídas
	assign dat_act = dat_act_h && dat_act_v;
	assign disp_RGB = (dat_act) ?  data : 3'h00;     
	assign vga_r = disp_RGB[0];
	assign vga_g = disp_RGB[1];
	assign vga_b = disp_RGB[2];
	//--------------------------------------------
	
	//************************VGA EXIBIÇÃO*******************************

	// Lógica para escolha do que será exibido na tela
	always @(posedge vga_clk)
	L1 : begin
		case(sel)
			1'b0: data <= dat_draw;
			1'b1: data <= WHITE; //limpa tela
		endcase
	end
		
	//Lógica para gerar a saída dat_draw
	always @(posedge vga_clk)
	begin
		 localparam TOP_X = 150;
		 localparam ESQ_Y = 41;
		 
	    draw_bg(BLACK);
		 
		 draw_sqr(TOP_X, ESQ_Y, 1, WHITE);
		 
		 draw_E(TOP_X, ESQ_Y, 1, WHITE);
		 draw_L(TOP_X+13, ESQ_Y, 1, WHITE);
		 draw_E(TOP_X+24, ESQ_Y, 1, WHITE);
		 draw_T(TOP_X+37, ESQ_Y, 1, WHITE);
		 draw_R(TOP_X+53, ESQ_Y, 1, WHITE);
		 draw_O(TOP_X+64, ESQ_Y, 1, WHITE);
		 draw_N(TOP_X+76, ESQ_Y, 1, WHITE);
		 draw_I(TOP_X+94, ESQ_Y, 1, WHITE);
		 draw_C(TOP_X+97, ESQ_Y, 1, WHITE);
		 draw_A(TOP_X+109, ESQ_Y, 1, WHITE);
		 
		 draw_D(TOP_X+126, ESQ_Y, 1, WHITE);
		 draw_I(TOP_X+139, ESQ_Y, 1, WHITE);
		 draw_G(TOP_X+143, ESQ_Y, 1, WHITE);
		 draw_I(TOP_X+158, ESQ_Y, 1, WHITE);
		 draw_T(TOP_X+161, ESQ_Y, 1, WHITE);
		 draw_A(TOP_X+175, ESQ_Y, 1, WHITE);
		 draw_L(TOP_X+188, ESQ_Y, 1, WHITE);
		 
		 draw_1(TOP_X+204, ESQ_Y, 1, WHITE);
		 draw_A(TOP_X+215, ESQ_Y, 1, WHITE);
		 
		 draw_P(TOP_X, ESQ_Y+25, 1, WHITE);
		 draw_R(TOP_X+12, ESQ_Y+25, 1, WHITE);
		 draw_O(TOP_X+24, ESQ_Y+25, 1, WHITE);
		 draw_J(TOP_X+37, ESQ_Y+25, 1, WHITE);
		 draw_E(TOP_X+48, ESQ_Y+25, 1, WHITE);
		 draw_T(TOP_X+58, ESQ_Y+25, 1, WHITE);
		 draw_O(TOP_X+74, ESQ_Y+25, 1, WHITE);
		 draw_4(TOP_X+90, ESQ_Y+25, 1, WHITE);
		 draw_2Pontos(TOP_X+102, ESQ_Y+33, 1, WHITE);
		 
		 draw_M(TOP_X+108, ESQ_Y+25, 1, WHITE);
		 draw_U(TOP_X+130, ESQ_Y+25, 1, WHITE);
		 draw_S(TOP_X+143, ESQ_Y+25, 1, WHITE);
		 draw_I(TOP_X+156, ESQ_Y+25, 1, WHITE);
		 draw_C(TOP_X+160, ESQ_Y+25, 1, WHITE);
		 
		 draw_P(TOP_X+176, ESQ_Y+25, 1, WHITE);
		 draw_L(TOP_X+189, ESQ_Y+25, 1, WHITE);
		 draw_A(TOP_X+201, ESQ_Y+25, 1, WHITE);
		 draw_Y(TOP_X+214, ESQ_Y+25, 1, WHITE);
		 draw_E(TOP_X+234, ESQ_Y+25, 1, WHITE);
		 draw_R(TOP_X+249, ESQ_Y+25, 1, WHITE);
		 
		 draw_V(TOP_X+265, ESQ_Y+25, 1, WHITE);
		 draw_E(TOP_X+273, ESQ_Y+25, 1, WHITE);
		 draw_R(TOP_X+287, ESQ_Y+25, 1, WHITE);
		 draw_4(TOP_X+302, ESQ_Y+25, 1, WHITE);
		 
		 draw_M(TOP_X+89, ESQ_Y+50, 1, WHITE);
		 draw_O(TOP_X+111, ESQ_Y+50, 1, WHITE);
		 draw_D(TOP_X+124, ESQ_Y+50, 1, WHITE);
		 draw_E(TOP_X+137, ESQ_Y+50, 1, WHITE);
		 draw_L(TOP_X+151, ESQ_Y+50, 1, WHITE);
		 draw_A(TOP_X+163, ESQ_Y+50, 1, WHITE);
		 draw_D(TOP_X+176, ESQ_Y+50, 1, WHITE);
		 draw_O(TOP_X+189, ESQ_Y+50, 1, WHITE);
		 
		 draw_E(TOP_X+206, ESQ_Y+50, 1, WHITE);
		 draw_M(TOP_X+220, ESQ_Y+50, 1, WHITE);
		 
		 draw_V(TOP_X+250, ESQ_Y+50, 1, WHITE);
		 draw_E(TOP_X+258, ESQ_Y+50, 1, WHITE);
		 draw_R(TOP_X+272, ESQ_Y+50, 1, WHITE);
		 draw_I(TOP_X+285, ESQ_Y+50, 1, WHITE);
		 draw_L(TOP_X+289, ESQ_Y+50, 1, WHITE);
		 draw_O(TOP_X+301, ESQ_Y+50, 1, WHITE);
		 draw_G(TOP_X+314, ESQ_Y+50, 1, WHITE);
		 
		 draw_H(TOP_X+333, ESQ_Y+50, 1, WHITE);
		 draw_D(TOP_X+348, ESQ_Y+50, 1, WHITE);
		 draw_L(TOP_X+361, ESQ_Y+50, 1, WHITE);
		 
		 draw_E(TOP_X, ESQ_Y+361, 1, WHITE);
		 draw_Q(TOP_X+14, ESQ_Y+361, 1, WHITE);
		 draw_U(TOP_X+26, ESQ_Y+361, 1, WHITE);
		 draw_I(TOP_X+38, ESQ_Y+361, 1, WHITE);
		 draw_P(TOP_X+41, ESQ_Y+361, 1, WHITE);
		 draw_E(TOP_X+53, ESQ_Y+361, 1, WHITE);
		 draw_2Pontos(TOP_X+67, ESQ_Y+361, 1, WHITE);
		 
		 draw_A(TOP_X+73, ESQ_Y+361, 1, WHITE);
		 draw_L(TOP_X+85, ESQ_Y+361, 1, WHITE);
		 draw_E(TOP_X+97, ESQ_Y+361, 1, WHITE);
		 draw_X(TOP_X+111, ESQ_Y+361, 1, WHITE);
		 draw_A(TOP_X+133, ESQ_Y+361, 1, WHITE);
		 draw_N(TOP_X+145, ESQ_Y+361, 1, WHITE);
		 draw_D(TOP_X+163, ESQ_Y+361, 1, WHITE);		 
		 draw_R(TOP_X+175, ESQ_Y+361, 1, WHITE);		 
		 draw_E(TOP_X+187, ESQ_Y+361, 1, WHITE);
		 
		 draw_L(TOP_X+204, ESQ_Y+361, 1, WHITE);
		 draw_U(TOP_X+216, ESQ_Y+361, 1, WHITE);
		 draw_I(TOP_X+228, ESQ_Y+361, 1, WHITE);
		 draw_Z(TOP_X+231, ESQ_Y+361, 1, WHITE);
		 
		 draw_E(TOP_X+73, ESQ_Y+386, 1, WHITE);
		 draw_U(TOP_X+87, ESQ_Y+386, 1, WHITE);
		 draw_N(TOP_X+99, ESQ_Y+386, 1, WHITE);
		 draw_I(TOP_X+117, ESQ_Y+386, 1, WHITE);
		 draw_C(TOP_X+120, ESQ_Y+386, 1, WHITE);
		 draw_E(TOP_X+133, ESQ_Y+386, 1, WHITE);
		 
		 draw_T(TOP_X+150, ESQ_Y+386, 1, WHITE);
		 draw_E(TOP_X+167, ESQ_Y+386, 1, WHITE);
		 draw_N(TOP_X+181, ESQ_Y+386, 1, WHITE);
		 draw_O(TOP_X+199, ESQ_Y+386, 1, WHITE);
		 draw_R(TOP_X+211, ESQ_Y+386, 1, WHITE);
		 draw_I(TOP_X+223, ESQ_Y+386, 1, WHITE);
		 draw_O(TOP_X+226, ESQ_Y+386, 1, WHITE);
		 
		 draw_J(TOP_X+73, ESQ_Y+411, 1, WHITE);
		 draw_O(TOP_X+83, ESQ_Y+411, 1, WHITE);
		 draw_S(TOP_X+95, ESQ_Y+411, 1, WHITE);
		 draw_E(TOP_X+108, ESQ_Y+411, 1, WHITE);
		 
		 draw_A(TOP_X+125, ESQ_Y+411, 1, WHITE);
		 draw_U(TOP_X+137, ESQ_Y+411, 1, WHITE);
		 draw_G(TOP_X+149, ESQ_Y+411, 1, WHITE);
		 draw_U(TOP_X+163, ESQ_Y+411, 1, WHITE);
		 draw_S(TOP_X+175, ESQ_Y+411, 1, WHITE);
		 draw_T(TOP_X+188, ESQ_Y+411, 1, WHITE);
		 draw_O(TOP_X+205, ESQ_Y+411, 1, WHITE);
		
		 draw_M(TOP_X, ESQ_Y+89, 1, WHITE);
		 draw_U(TOP_X+21, ESQ_Y+89, 1, WHITE);
		 draw_S(TOP_X+34, ESQ_Y+89, 1, WHITE);
		 draw_I(TOP_X+48, ESQ_Y+89, 1, WHITE);
		 draw_C(TOP_X+51, ESQ_Y+89, 1, WHITE);
		 draw_A(TOP_X+64, ESQ_Y+89, 1, WHITE);
		 draw_2Pontos(TOP_X+76, ESQ_Y+97, 1, WHITE);
		
		 draw_O(TOP_X+82, ESQ_Y+89, 1, WHITE);
		 draw_V(TOP_X+94, ESQ_Y+89, 1, WHITE);
		 draw_E(TOP_X+101, ESQ_Y+89, 1, WHITE);
		 draw_R(TOP_X+115, ESQ_Y+89, 1, WHITE);
		
		 draw_T(TOP_X+130, ESQ_Y+89, 1, WHITE);
		 draw_H(TOP_X+147, ESQ_Y+89, 1, WHITE);
		 draw_E(TOP_X+161, ESQ_Y+89, 1, WHITE);
		
		 draw_R(TOP_X+178, ESQ_Y+89, 1, WHITE);
		 draw_A(TOP_X+190, ESQ_Y+89, 1, WHITE);
		 draw_I(TOP_X+202, ESQ_Y+89, 1, WHITE);
		 draw_N(TOP_X+205, ESQ_Y+89, 1, WHITE);
		 draw_B(TOP_X+221, ESQ_Y+89, 1, WHITE);
		 draw_O(TOP_X+235, ESQ_Y+89, 1, WHITE);
		 draw_W(TOP_X+247, ESQ_Y+89, 1, WHITE);
		 
		 draw_A(TOP_X, ESQ_Y+114, 1, WHITE);
		 draw_U(TOP_X+12, ESQ_Y+114, 1, WHITE);
		 draw_T(TOP_X+24, ESQ_Y+114, 1, WHITE);
		 draw_O(TOP_X+41, ESQ_Y+114, 1, WHITE);
		 draw_R(TOP_X+53, ESQ_Y+114, 1, WHITE);
		 draw_2Pontos(TOP_X+65, ESQ_Y+122, 1, WHITE);
		 
		 draw_Y(TOP_X+82, ESQ_Y+114, 1, WHITE);
		 draw_I(TOP_X+102, ESQ_Y+114, 1, WHITE);
		 draw_P(TOP_X+105, ESQ_Y+114, 1, WHITE);
		 
		 draw_H(TOP_X+120, ESQ_Y+114, 1, WHITE);
		 draw_A(TOP_X+134, ESQ_Y+114, 1, WHITE);
		 draw_R(TOP_X+146, ESQ_Y+114, 1, WHITE);
		 draw_B(TOP_X+158, ESQ_Y+114, 1, WHITE);
		 draw_U(TOP_X+170, ESQ_Y+114, 1, WHITE);
		 draw_R(TOP_X+182, ESQ_Y+114, 1, WHITE);
		 draw_G(TOP_X+194, ESQ_Y+114, 1, WHITE);
		
	end
	
	//TASK: Lógica para desenhar background
	task draw_bg(input [3:1] COLOR);
    begin
        if (vcount >= 0 && vcount < 480 && hcount >= 0 && hcount < 640) 
				dat_draw <= COLOR;  
    end
	endtask
	
	//TASK: Lógica para desenhar o quadrado
	task draw_sqr (input [10:1] POSX, POSY, WIDTH, input [3:1] COLOR);
    begin
		if (vcount >= POSY && vcount < POSY+WIDTH*CHAR_HEIGHT && hcount >= POSX && hcount < POSX+WIDTH*CHAR_WIDTH) 
				dat_draw <= COLOR;            
    end
	endtask
	
	//TASK: Lógica para desenhar a letra A
	task draw_A(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		
		draw_sqr(POSX, POSY+19, THICK, COLOR);
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
		end
		
		for(i=0; i<20; i=i+1) begin
			draw_sqr(POSX+9, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra B
	task draw_B(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<6; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+8, POSY+1+i, THICK, COLOR);
		end
		
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+9, POSY+10+i, THICK, COLOR);
		end
	 end
	endtask	
	
	//TASK: Lógica para desenhar a letra c
	
	task draw_C(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<9; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<9; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra D
	
	task draw_D(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
		
		for(i=0; i<17; i=i+1) begin
			draw_sqr(POSX+9, POSY+1+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra E
	task draw_E(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
								
		for(i=0; i<10; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
				
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
		end
				
		for(i=0; i<10; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra F
	
//	task draw_F(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//	 begin
//		integer i;
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX, POSY+i, THICK, COLOR);
//		end
//								
//		for(i=0; i<10; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
//		end
//				
//		for(i=0; i<8; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
//		end		
//	 end
//	endtask
	
	//TASK: Lógica para desenhar a letra G
	
	task draw_G(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<10; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<10; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
		
		for(i=0; i<9; i=i+1) begin
			draw_sqr(POSX+11, POSY+9+i, THICK, COLOR);
		end
		
		for(i=0; i<5; i=i+1) begin
			draw_sqr(POSX+5+i, POSY+9, THICK, COLOR);
		end
		
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra H
	
	task draw_H(input [10:1] POSX, POSY, THICK, input[3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<9; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+11, POSY+i, THICK, COLOR);
		end		
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra I
	
	task draw_I(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra J
	
	task draw_J(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+i, POSY+19, THICK, COLOR);
		end
		
		for(i=0; i<18; i=i+1) begin
			draw_sqr(POSX+8, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenahr a letra K
	
//	task draw_K(input [10:1] POSX, POSY, THICK, input[3:1] COLOR);
//	 begin
//		integer i;
//		for (i=0; i<19; i=i+1) begin
//			draw_sqr(POSX, POSY+i, THICK, COLOR);
//		end
//		
//		for (i=0; i<8; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+8-i, THICK, COLOR);
//		end
//		
//		for (i=0; i<10; i=i+1) begin
//			draw_sqr(POSX+2+i, POSY+9+i, THICK, COLOR);
//		end
//	 end
//	endtask 
		
	//TASK: Lógica para desenhar a letra L
	
	task draw_L(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
	 begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
								
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end		
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra M
	
	task draw_M(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+18, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<16; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<18; i=i+1) begin
			draw_sqr(POSX+9, POSY+1+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra N
	
	task draw_N(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<12; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+1+i, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+14, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra O
	
	task draw_O(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+9, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenha a letra P
	
	task draw_P(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+12, THICK, COLOR);
		end
		for(i=0; i<12; i=i+1) begin
			draw_sqr(POSX+9, POSY+i, THICK, COLOR);
		end		
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra Q
	
	task draw_Q(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+9, POSY+i, THICK, COLOR);
		end
		for(i=0; i<3; i=i+1) begin
			draw_sqr(POSX+5, POSY+18+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra R
	
	task draw_R(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<6; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+10, THICK, COLOR);
		end
		
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+8, POSY+1+i, THICK, COLOR);
		end
		
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+9, POSY+11+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra S
	
	task draw_S(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<9; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
		end
		
		for(i=0; i<10; i=i+1) begin
			draw_sqr(POSX+9, POSY+9+i, THICK, COLOR);
		end
		
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+i, POSY+19, THICK, COLOR);
		end
	 end
	endtask
	 
	//TASK: Lógica para desenhar a letra T 
	
	task draw_T(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<14; i=i+1) begin
			draw_sqr(POSX+i, POSY, THICK, COLOR);
		end
		for(i=0; i<18; i=i+1) begin
			draw_sqr(POSX+7, POSY+1+i, THICK, COLOR);
		end
    end
   endtask
	
	//TASK: Lógica para desenhar a letra U
	
	task draw_U(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<7; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+9, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra V
	
	
	task draw_V(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<9; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		for(i=0; i<5; i=i+1) begin
			draw_sqr(POSX+1, POSY+10+i, THICK, COLOR);
		end
		for(i=0; i<3; i=i+1) begin
			draw_sqr(POSX+2, POSY+16+i, THICK, COLOR);
		end
		for(i=0; i<5; i=i+1) begin
			draw_sqr(POSX+3, POSY+10+i, THICK, COLOR);
		end
		for(i=0; i<9; i=i+1) begin
			draw_sqr(POSX+4, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar e letra W
	
	task draw_W(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+18, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<16; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
		end
		
		for(i=0; i<18; i=i+1) begin
			draw_sqr(POSX+9, POSY+1+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra X
	
	task draw_X(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+i, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+i, POSY+19-i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica pra desenhar a letra Y
	
	task draw_Y(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+i, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<10; i=i+1) begin
			draw_sqr(POSX+9, POSY+9+i, THICK, COLOR);
		end
		
		for(i=0; i<8; i=i+1) begin
			draw_sqr(POSX+10+i, POSY+8-i, THICK, COLOR);
		end		
	 end
	endtask
	
	//TASK: Lógica para desenhar a letra Z
	
	task draw_Z(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<17; i=i+1) begin
			draw_sqr(POSX+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<17; i=i+1) begin
			draw_sqr(POSX+17-i, POSY+1+i, THICK, COLOR);
		end
		
		for(i=0; i<17; i=i+1) begin
			draw_sqr(POSX+i, POSY+19, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar o numero 1
	
	task draw_1(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<3; i=i+1) begin
			draw_sqr(POSX+i, POSY, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+4, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar o número 2
	
//	task draw_2(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//    begin
//		integer i;
//		for(i=0; i<8; i=i+1) begin
//			draw_sqr(POSX+i, POSY, THICK, COLOR);
//		end
//		
//		for(i=0; i<9; i=i+1) begin
//			draw_sqr(POSX+9, POSY+1+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<7; i=i+1) begin
//			draw_sqr(POSX+i, POSY+9, THICK, COLOR);
//		end
//		
//		for(i=0; i<9; i=i+1) begin
//			draw_sqr(POSX, POSY+10+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<7; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
//		end
//	 end
//	endtask
	
	//TASK: Lógica para desenhar o número 3
	
//	task draw_3(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//    begin
//		integer i;
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX+9, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<8; i=i+1) begin
//			draw_sqr(POSX+i, POSY, THICK, COLOR);
//		end
//		
//		for(i=0; i<7; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
//		end
//		
//		for(i=0; i<8; i=i+1) begin
//			draw_sqr(POSX+i, POSY+19, THICK, COLOR);
//		end
//	 end
//	endtask
	
	//TASK: Lógica para desenhar o número 4
	
	task draw_4(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
		for(i=0; i<13; i=i+1) begin
			draw_sqr(POSX, POSY+i, THICK, COLOR);
		end
		
		for(i=0; i<6; i=i+1) begin
			draw_sqr(POSX+1+i, POSY+13, THICK, COLOR);
		end
		
		for(i=0; i<19; i=i+1) begin
			draw_sqr(POSX+8, POSY+i, THICK, COLOR);
		end
	 end
	endtask
	
	//TASK: Lógica para desenhar o número 5
	
//	task draw_5(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//    begin
//		integer i;
//		for(i=0; i<8; i=i+1) begin
//			draw_sqr(POSX, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<11; i=i+1) begin
//			draw_sqr(POSX+7, POSY+8+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
//		end
//		
//		for(i=0; i<5; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+8, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+i, POSY+19, THICK, COLOR);
//		end
//	 end
//	endtask
//	
//	//TASK: Lógica para desenhar o número 6
//	
//	task draw_6(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//    begin
//		integer i;
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<12; i=i+1) begin
//			draw_sqr(POSX+8, POSY+7+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<7; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+7, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
//		end
//	 end
//	endtask
//	
//	//TASK: Lógica para desenhar o número 7
//	
//	task draw_7(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//    begin
//		integer i;
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX+9, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<8; i=i+1) begin
//			draw_sqr(POSX+i, POSY, THICK, COLOR);
//		end
//	 end
//	endtask
//	
//	//TASK: Lógica para desenhar o número 8
//	
//	task draw_8(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//    begin
//		integer i;
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX+8, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
//		end
//	 end
//	endtask
//	
//	//TASK: Lógia para desenhar o número 9
//	
//	task draw_9(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//    begin
//		integer i;
//		for(i=0; i<12; i=i+1) begin
//			draw_sqr(POSX, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX+8, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+12, THICK, COLOR);
//		end
//		
//		for(i=0; i<7; i=i+1) begin
//			draw_sqr(POSX+i, POSY+19, THICK, COLOR);
//		end
//	 end
//	endtask
//	
//	//TASK: Lógica para desenhar o número 0
//	
//	task draw_0(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
//    begin
//		integer i;
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<19; i=i+1) begin
//			draw_sqr(POSX+8, POSY+i, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+9, THICK, COLOR);
//		end
//		
//		for(i=0; i<6; i=i+1) begin
//			draw_sqr(POSX+1+i, POSY+19, THICK, COLOR);
//		end
//	 end
//	endtask
	
	//TASK: Lógica para desenhar dois pontos
	
	task draw_2Pontos(input [10:1] POSX, POSY, THICK, input [3:1] COLOR);
    begin
		integer i;
			draw_sqr(POSX, POSY, THICK, COLOR);
			draw_sqr(POSX, POSY+10, THICK, COLOR);
	 end
	endtask
endmodule
