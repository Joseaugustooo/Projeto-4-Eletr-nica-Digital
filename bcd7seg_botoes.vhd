-- Arquivo: bcd7seg_botoes.vhd
-- Descrição: Exibe um valor no display selecionado pelo botão
-- Autor: Malki-çedheq Benjamim
-- Data: 04/02/2022
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY bcd7seg_botoes IS
	PORT (bcd : IN integer; 
			--todos os segmentos INativos (ativo-baixo)
			seg : OUT std_logic_vector (7 DOWNTO 0) := X"FF"
			--todos os dígitos INativos (ativo-baixo)
	);
END bcd7seg_botoes;
ARCHITECTURE bhv OF bcd7seg_botoes IS
	--Sinais
BEGIN
	--número a ser exibido nos display
	
	--ordem invertida para casar a sequencia binária com
	--a disposição dos botões na placa de desenvolvimento
	-- Decodificador BCD 7 SEG
	PROCESS(bcd)
	BEGIN
		CASE bcd IS -- tabela verdade 7 seg anodo comum
			--display seg6,seg5,seg4,seg3,seg2,seg1,seg0;
			WHEN 0 => seg(6 DOWNTO 0) <= B"1000000";
			WHEN 1 => seg(6 DOWNTO 0) <= B"1111001";
			WHEN 2 => seg(6 DOWNTO 0) <= B"0100100";
			WHEN 3 => seg(6 DOWNTO 0) <= B"0110000";
			WHEN 4 => seg(6 DOWNTO 0) <= B"0011001";
			WHEN 5 => seg(6 DOWNTO 0) <= B"0010010";
			WHEN 6 => seg(6 DOWNTO 0) <= B"0000010";
			WHEN 7 => seg(6 DOWNTO 0) <= B"1111000";
			WHEN 8 => seg(6 DOWNTO 0) <= B"0000000";
			WHEN 9 => seg(6 DOWNTO 0) <= B"0010000";
			WHEN OTHERS => seg(6 DOWNTO 0) <= B"1111111";
		END CASE;
	END PROCESS;
END bhv;