module dm(
input logic clk,		//Clock
input logic rst,		//Reset
input logic [7:0] signal_in,	//Sinal do comparador a ser demodulado	
output logic bitout,    //Bit demodulado  
output logic bitsinc    //Ocorrencia de bit demodulado
output logic [15:0] demodulado; // Vetor com os dois bytes de dados atualizados constantemente
										//(Ao final da transmissao de 16 bits, possui os dois bytes completos)
);

logic [1:0]sample_reg;	//Registro da amostra para verificação da 
								 //passagem por zero
logic [7:0]contador;      //Contagem de amostras
logic flag;               //Indicação da ocorrência da primeira borda de                            
								//frequencia 1khz
logic borda;					//Transição de "zeros" presentes no ciclo

logic [15:0] posBitAtual; // Indica a posicao do bit de dado atual 
								 //(somente um dos bits, dentre os 16, fica em nivel logico 1 por vez)
logic [15:0] bitAtual;	// Vetor de 16 bits em que todos os bits assumem o mesmo valor logico do bit de dado atual
								// (Todos em 1 ou todos em 0, dependendo do estado logico do bit de dado atual)

always_ff @(posedge clk or posedge rst) begin
  if(rst) begin         //Etapa de registro e verificação de ocorrência    
	sample_reg <= 0;    //de borda
	borda <= 0;
	end
	else begin
	sample_reg <= {sample_reg[1:0],signal_in[7]};
	end
	
	borda <= (sample_reg[1] ^ sample_reg[0]);
end



always_ff @(posedge clk or posedge rst) begin
   if(rst) begin              //Etapa de contagem de amostras
		contador<= 8'd0;        
	end
	else if (borda) begin
		contador <= 8'd0;
	end
	else
		contador <= contador + 8'd1;
	
end
  
  
  
always_ff @(posedge clk or posedge rst) begin
  if (rst)                    //Estapa de verificação da primeira borda
	flag <= 0;                //da frequencia 1kHz
  else if (borda)
    if (contador <= 8'd24)
		flag <= 1'b1;
    else 
    	flag <= 1'b0;
  //else if (bitsinc)
    //flag <= 1'b0;
  else
    flag<=flag;
end

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin                //Demodulação (decisão a partir
    bitout <= 0;                //da frequência entre bit 0 ou 1);
	end
	else 
	if (borda) begin
      if ((contador <= 8'd24) && flag) begin
			bitout <= 1'b0;
		end
      else if (contador > 8'd24) begin
		    bitout <= 1'b1;
        end
   end
   else 
	bitout <= bitout;
end
  
  always_ff @(posedge clk or posedge rst) begin
    if (rst) 	    //Etapa de detecção da ocorrência de bit demodulado
       bitsinc <= 1'b0;
    else 
      bitsinc <= (borda & flag) | ((contador > 8'd24) & borda);
  end

always_ff @(posedge bitsinc) begin
	if(posBitAtual == 16'b0)
		posBitAtual <= 16'b1000000000000000;
	else
		posBitAtual <= posBitAtual >> 1;
end

always_comb begin
	if(posBitAtual == 16'b0)
		demodulado <= 16'b0;
	else
		demodulado <= demodulado | (bitAtual & posBitAtual);
end

always_comb begin
	if (bitout)
		bitAtual <= 16'b1111111111111111;
	else
		bitAtual <= 16'b0;
end

endmodule
