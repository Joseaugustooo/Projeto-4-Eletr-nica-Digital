/*
Autor: Malki-çedheq Benjamim
Disciplina: Eletrônica Digital 1A
Descrição: (ESTRUTURAL)
Principio de interface VGA, ex. sinal para teste de cores e sincronização v/h
Conecte a interface VGA da placa de desenvolvimento a um monitor/tv,
são utilizadas as chaves/botões key1 e key2, da seguinte forma:

key1 key2  resultado esperado no monitor
 0    0	  barra de cores horizontal	
 0    1    barra de cores vertical
 1    0    tabuleiro colorido
 1    1    outro
 
Referência: 
	https://web.mit.edu/6.111/www/labkit/vga.shtml
	http://tinyvga.com/vga-timing/640x480@60Hz
	
Detalhamento:

	O módulo `VGA_interface` é um módulo de interface VGA completo que combina os sinais gerados pelos módulos `horizontal_sync`, `vertical_sync` e `pixel_generator` para criar uma saída VGA que pode ser conectada a um monitor ou outro dispositivo de exibição VGA. Esse módulo é projetado para controlar e exibir imagens na tela de acordo com as configurações de temporização VGA e os sinais de controle.

	1. **Entradas:**
		- `clock`: O sinal de clock do sistema.
		- `key`: Sinal de entrada que representa as chaves ou botões da placa de desenvolvimento. Essas entradas são usadas para selecionar os diferentes modos de exibição.
		
	2. **Saídas:**
		- `vga_r`, `vga_g`, `vga_b`: Sinais de saída que representam os componentes vermelho, verde e azul do sinal VGA. Esses sinais são usados para controlar as cores dos pixels na tela.
		- `hsync`: Sinal de sincronização horizontal.
		- `vsync`: Sinal de sincronização vertical.
		
	3. **Instâncias dos Módulos:**
		- O módulo instância os módulos `horizontal_sync`, `vertical_sync` e `pixel_generator` para gerar os sinais de sincronização horizontal, sincronização vertical e os dados RGB dos pixels.
		
	4. **Conexões entre Módulos:**
		- Os sinais gerados pelos módulos instanciados (`hsync`, `vsync`, `hcount`, `vcount`, `dat_act_h`, `dat_act_v`, `vga_r`, `vga_g`, `vga_b`) são interconectados para criar a interface VGA completa.
		
	5. **Funcionamento do Módulo:**
		- O módulo `VGA_interface` coordena os sinais de sincronização horizontal e vertical gerados pelos módulos `horizontal_sync` e `vertical_sync`, respectivamente.
		- O sinal de ativação de pixels (`dat_act_h` e `dat_act_v`) do módulo `pixel_generator` é usado para ativar os pixels da tela somente durante as regiões ativas da varredura horizontal e vertical.
		- Os sinais `hsync` e `vsync` são gerados de acordo com os tempos de sincronização definidos nos módulos `horizontal_sync` e `vertical_sync`.
		- Os sinais `vga_r`, `vga_g` e `vga_b` são os sinais de cores que definem a cor dos pixels exibidos na tela. Eles são gerados pelo módulo `pixel_generator` e controlam a cor de cada pixel exibido.
		
	6. **Controle de Modos de Exibição:**
		- O sinal `key` é usado para selecionar diferentes modos de exibição, como barras de cores horizontais, barras de cores verticais, tabuleiro colorido, etc.
		
	O módulo `VGA_interface` é o componente principal que integra todos os aspectos necessários para a geração da saída VGA e a exibição de imagens na tela de um monitor compatível com VGA. 
	Ele combina a sincronização horizontal e vertical com a geração de pixels coloridos para criar a imagem final que será exibida na tela.

*/
module VGA_interface(
   clock,
   //key,
	sel,
   vga_r, vga_g, vga_b,
   hsync,
   vsync,
	decimo,uni_segundo,dec_segundo,minuto
);
	input  clock;     	//50MHz clock de entrada do sistema
	//input  [2:1] key;  	//conexão com chaves/botes da placa
	input sel;
	output  vga_r, vga_g, vga_b;    //Saída de dados VGA
	output  hsync;     	//Sinal para sincronização horizontal VGA
	output  vsync;     	//Sinal para sincronização vertical VGA
	input [4:1] decimo,uni_segundo,dec_segundo,minuto;
	
	//Conduções para instâncias
	wire [9:0] hcount;
	wire [9:0] vcount;	
	wire hcount_ov;
	wire dat_act_h;
	wire dat_act_v;
	wire vr1,vg1,vb1;
	wire vr2,vg2,vb2;
	wire vr3,vg3,vb3;
	reg conta = 1'b1;
	
//	always @ (clock)
//	begin
//		if (sel ==1'b0)
//		begin
//			vr <= vr1;
//			vg = vg1;
//			vb = vb1;
//		end
//		else
//			vr = vr2;
//			vg = vg2;
//			vb = vb2;
//	end

	//Instância e mapeamento do módulo de sincronismo horizontal
	horizontal_sync hs1( .clock(clock),
								.hsync(hsync),
								.hcount(hcount),
								.hcount_ov(hcount_ov),
								.dat_act_h(dat_act_h));
	
	//Instância e mapeamento do módulo de sincronismo vertical						
	vertical_sync vs1(   .clock(clock),
								.hcount_ov(hcount_ov),
								.vsync(vsync),
								.vcount(vcount),
								.dat_act_v(dat_act_v));	
	
	//Instância e mapeamento do módulo gerador de pixels
	pixel_generator pg1(   .clock(clock),   
								.dat_act_h(dat_act_h),
								.dat_act_v(dat_act_v),
								.hcount(hcount),
								.vcount(vcount),
								.sel(sel),
								.vga_r(vr1), 
								.vga_g(vg1), 
								.vga_b(vb1));
								
	pixel_generator1 pg2(   .clock(clock),   
								.dat_act_h(dat_act_h),
								.dat_act_v(dat_act_v),
								.hcount(hcount),
								.vcount(vcount),
								.sel(sel),
								.vga_r(vr2), 
								.vga_g(vg2), 
								.vga_b(vb2));
								
	contagem pg3(   .clock(clock),   
								.dat_act_h(dat_act_h),
								.dat_act_v(dat_act_v),
								.hcount(hcount),
								.vcount(vcount),
								.sel(conta),
								.vga_r(vr3), 
								.vga_g(vg3), 
								.vga_b(vb3),
								.decimo(decimo),
								.uni_segundo(uni_segundo),
								.dec_segundo(dec_segundo),
								.minuto(minuto));
								
	assign vga_r = (vr1 & vr2) ^ vr3;
	assign vga_g = (vg1 & vg2) ^ vg3;
	assign vga_b = (vb1 & vb2) ^ vb3;
endmodule
