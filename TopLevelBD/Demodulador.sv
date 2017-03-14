module Demodulador(
  input logic G_CLK_RX,
  input logic [7:0] ADC,
  output logic int_rx_host,
  output logic [7:0] DATA_BYTE_0,
  output logic [7:0] DATA_BYTE_1,
  inout logic [7:0] BD_CONTROL_IN,
  input logic reset
);

logic [7:0] contaZeros = 0;
logic [4:0] contaClocks = 0;

logic [3:0] currentBitAddress; // Armazena o endereco atual do bit de informacao
/*
	Explicacao:

	Quando currentBitAddress estah entre 0 e 7 (inclusivo), os bits de dados
	pertencem ao DATA_BYTE_1.

	Quando currentBitAddress estah entre 8 e 15 (inclusivo), os bits de dados
	pertencem ao DATA_BYTE_0.
*/

logic lastSign = 0; // Armazena o bit de sinal da amostragem anterior
logic STATUS, INTFLAG, INTMASK, RXENABLE; // Bits de controle da especificacao

// Atribuindo nomes mais significativos aos bits de controle,
// de acordo com a especificacao:
assign STATUS 		= BD_CONTROL_IN[3];
assign INTFLAG 	= BD_CONTROL_IN[2];
assign INTMASK 	= BD_CONTROL_IN[1];
assign RXENABLE 	= BD_CONTROL_IN[0];

// Always principal que conta as passagens por zero
always_ff @(posedge G_CLK_RX or posedge reset) begin

	if(reset) begin // Inicio do if de reset
		// Prioridade dada ao bit de reset
		contaClocks = 0;
		contaZeros = 0;
		lastSign = ADC[7];
	end // Fim do if de reset
	else // Caso reset esteja desativado, segue rotina padrao
	begin // Inicio do else do reset
		// Se ultimo bit de sinal for diferente do atual, houve uma passagem por zero
		if(lastSign != ADC[7]) begin // Inicio do if de mudanca de sinal

			contaZeros = contaZeros + 1;

			// Atribui lastSign dentro do if para garantir sequencialidade
			// (ou seja, soh atualiza o lastSign depois que passar pelo teste do if)
			lastSign = ADC[7];

		end // Fim do if de mudanca de sinal
		else // Se nao houve mudanca de sinal, soh atualiza o ultimo sinal
		begin // Inicio do else de mudanca de sinal
			contaZeros = contaZeros;
			// Atribui lastSign dentro do if para garantir sequencialidade
			lastSign = ADC[7];
		end // Fim do else de mudanca de sinal
	end // Fim do else do reset
end // Fim do always de contagem de passagens por zero

// Always de ajuste de endereco do bit de dado
always_ff @(contaClocks) begin

	if(contaClocks == 5'd31) begin // Inicio do top if
		// Ao final de 32 pulsos de clock, avalia um bit de dado
		
		currentBitAddress = currentBitAddress + 4'b0001; // Incrementa o currentBitAddress
		/*
			Quando o currentBitAddress atinge 31, o proprio overflow se encarrega de
			zerar o endereco.
		*/
		
		if(contaZeros <= 0) begin // Inicio do if do bit de dado == 1
			// Bit de dado eh 1
			if(currentBitAddress < 8) begin // Inicio do if para dado em DATA_BYTE_1.
				/*
				Quando currentBitAddress estah entre 0 e 7 (inclusivo),
				estamos recebendo os bits do DATA_BYTE_1.

				Bits de DATA_BYTE_1: [[ ][ ][ ][ ][ ][ ][ ][ ]]
				Indice de acesso: 	[ 7  6  5  4  3  2  1  0 ]

				Entao, fazendo 7 - currentBitAddress, obtemos o indice
				para o DATA_BYTE_1.
				*/
				DATA_BYTE_1[7 - currentBitAddress] = 1'b1;
			end // Fim do if para dado em DATA_BYTE_1.
			else begin // Inicio do else para bit de dado == 1 em DATA_BYTE_0.
				DATA_BYTE_0[15 - currentBitAddress] = 1'b1;
			end // Fim do else para bit de dado == 1 em DATA_BYTE_0.
      end // Fim do if do bit de dado == 1
      else // Se chegar neste else, bit de dado eh 0.
      begin // Inicio do else de bit de dado == 0.
        // Bit de dado eh 0.
        if(currentBitAddress < 8) begin // Inicio do if para dado em DATA_BYTE_1.
          DATA_BYTE_1[7 - currentBitAddress] = 1'b0;
        end // Fim do if para dado em DATA_BYTE_1.
        else begin // Inicio do else para bit de dado == 1 em DATA_BYTE_0.
          DATA_BYTE_0[15 - currentBitAddress] = 1'b0;
        end // Fim do else para bit de dado == 1 em DATA_BYTE_0.
      end // Fim do else de bit de dado == 0.
		else begin // Inicio do else do top if
			contaClocks = contaClocks;
		end // Fim do else do top if

end // Fim do always de ajuste de endereco do bit de dado


// Always de incremento do contador de clocks
always_ff @(posedge G_CLK_RX) begin
	if(contaClocks == 6'd32) begin
		// Finalizou as leituras de um bit
		contaZeros = 0;
		contaClocks = 0;
	end
	else begin
		contaClocks = contaClocks + 1;
	end
end // Fim do always de incremento do contador de clocks

endmodule
