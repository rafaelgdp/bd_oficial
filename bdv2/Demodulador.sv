module Demodulador(
  input logic G_CLK_RX,
  input logic [7:0] sinal,
  output logic int_rx_host,
  output logic [7:0] DATA_BYTE_0,
  output logic [7:0] DATA_BYTE_1,
  inout logic [7:0] BD_CONTROL_IN,
  input logic reset
);

   

logic STATUS, INTFLAG, INTMASK, RXENABLE; // Bits de controle da especificacao

// Atribuindo nomes mais significativos aos bits de controle,
// de acordo com a especificacao:
assign STATUS 		= BD_CONTROL_IN[3];
assign INTFLAG 	= BD_CONTROL_IN[2];
assign INTMASK 	= BD_CONTROL_IN[1];
assign RXENABLE 	= BD_CONTROL_IN[0];

logic bitout;
logic flag;

logic ff1, ff2;
logic [7:0] contador;
logic detectBorda;

/********************************************************************************************************************************/


// detector de bordas
always_ff @(posedge G_CLK_RX or posedge reset) 
begin
	ff1 <= signal;
	ff2 <= ff1;
end

always_comb
begin
	detectBorda <= ff1^ff2;
end


// contador que zera quando sempre que ocorre uma borda 

always_ff @(posedge G_CLK_RX or negedge reset)
begin
	if (~reset)
		contador <= 5'd0;
	else
		if (detectBorda)
			contador <= 5'd0;
		else
			contador <= contador + 5'd1;
end


// INCOMPLETO
always_ff @(posedge G_CLK_RX or negedge reset)
begin	
	 if (detectBorda)	
	   begin
			if (contador <= 5'd24) // se contador for menor que 24, ou seja, teve um cruzamento por zero no pulso de clock 15,  
				flag <= ~flag;
		   else
			   bitout <= 1;
		end
	else
		bitout <= bitout;
		
end






endmodule

