module Demodulador(
  input logic G_CLK_RX,
  
  //input logic  [7:0]in_signal,
  
 // output logic int_rx_host,
  //output logic [7:0] DATA_BYTE_0,
  //output logic [7:0] DATA_BYTE_1,
  //inout logic [7:0] BD_CONTROL_IN,
  
  input logic reset,
  output logic status,
  output logic [15:0]data
);

   
//logic STATUS, INTFLAG, INTMASK, RXENABLE; // Bits de controle da especificacao

// Atribuindo nomes mais significativos aos bits de controle,
// de acordo com a especificacao:
//assign STATUS 		= BD_CONTROL_IN[3];
//assign INTFLAG 	= BD_CONTROL_IN[2];
//assign INTMASK 	= BD_CONTROL_IN[1];
//assign RXENABLE 	= BD_CONTROL_IN[0];

logic bitout;
logic flag;
logic bitsync;
logic signal;
logic [7:0] buffer_1;
logic [7:0] buffer_2;

  
logic ff1, ff2;
logic [7:0] contador;
logic detectBorda;
  
 /*********************************************************************************************************************************/ 
 // Apenas para testes
  
 logic  [7:0]in_signal;
  always_ff @(posedge G_CLK_RX or posedge reset) 
  begin
    if (reset) 
      in_signal <= 'd128;
    else
      begin
        case (contador)
        	'd0: in_signal = 'd128;
            'd1: in_signal = 'd153;
            'd2: in_signal = 'd177;
            'd3: in_signal = 'd199;
            'd4: in_signal = 'd218;
            'd5: in_signal = 'd234;
            'd6: in_signal = 'd246;
            'd7: in_signal = 'd253;
            'd8: in_signal = 'd255;
            'd9: in_signal = 'd253;
            'd10: in_signal = 'd246;
            'd11: in_signal = 'd234;
            'd12: in_signal = 'd218;
            'd13: in_signal = 'd199;
            'd14: in_signal = 'd177;
            'd15: in_signal = 'd153;
            'd16: in_signal = 'd128;
            'd17: in_signal = 'd103;
            'd18: in_signal = 'd79;
            'd19: in_signal = 'd57;
            'd20: in_signal = 'd38;
            'd21: in_signal = 'd22;
            'd22: in_signal = 'd10;
            'd23: in_signal = 'd3;
            'd24: in_signal = 'd1;
            'd25: in_signal = 'd3;
            'd26: in_signal = 'd10;
            'd27: in_signal = 'd22;
            'd28: in_signal = 'd38;
            'd29: in_signal = 'd57;
            'd30: in_signal = 'd79;
            'd31: in_signal = 'd103;
        endcase
      end
  end
  

/********************************************************************************************************************************/

  
// Grampeador
always_ff @(posedge G_CLK_RX or posedge reset) 
 begin
   if (reset)
     begin
       signal <= 'd0;
     end
   else if (in_signal > 8'd128)
     begin
       signal <= 'd1;
     end
   else
     begin
        signal <= 'd0;
     end
 end
  
  
// status
always_ff @(posedge G_CLK_RX or posedge reset) 
 begin
   if (reset)
     begin
   		buffer_1 <= 0;
       	buffer_2 <= 0;
     end 
   else
     begin
     	buffer_1 <= in_signal;
        buffer_2 <= buffer_1;
     end
end
  
  
always_ff @(posedge G_CLK_RX or posedge reset) 
 begin
   if (reset)
     begin
     	status <= 'd0;
     end
   else
     begin
       if (buffer_1 == buffer_2)
         begin
           status <= 'd0;
         end
       else
         begin
           status <= 'd1;
         end
     end
 end

  
  
// detector de bordas
always_ff @(posedge G_CLK_RX or posedge reset) 
begin
	ff1 <= signal;
	ff2 <= ff1;
end

always_ff @(posedge G_CLK_RX or posedge reset) 
begin
	if (reset)
		detectBorda <= 0;
	else
		detectBorda <= ff1^ff2;
end


// contador que zera quando sempre que ocorre uma borda 
always_ff @(posedge G_CLK_RX or posedge reset)
begin
	if (reset)
		contador <= 5'd0;
	else
		if (detectBorda)
			contador <= 5'd0;
		else
			contador <= contador + 5'd1;
end


// always que gera o sinal flag
always_ff @(posedge G_CLK_RX or posedge reset)
begin	
	 if (reset)
		 begin
				flag <= 0;
		 end
	 else
		begin
			if (detectBorda)	
				begin
					if (contador <= 5'd24) // se contador for menor que 24, ou seja, teve um cruzamento por zero no pulso de clock 15,  
						flag <= ~flag; // teve borda e contador eh menor que 24
					else
						flag <= flag;
				end
			else
					flag <= flag;
		end
end
	

//always que escreve no bit de saida
always_ff @(posedge G_CLK_RX or posedge reset)
begin	
	 if (reset)
		 begin
				bitout <= 0;
		 end	
	 else
		begin
			if (detectBorda)
				begin
					if ( (contador <= 24) && (flag) ) 
						bitout <= 1;
					else if (contador > 24)
						bitout <= 0;
					else
						bitout <= bitout;
				end
			else
					bitout <= bitout;
		end
end


 // bitsync sinaliza que um novo bit foi recebido 
always @(posedge G_CLK_RX or posedge reset)
begin
  if (reset)
    begin
    	bitsync <= 0;
    end
  else
  	begin
      if ((contador > 24) && (detectBorda == 1))
      	bitsync <= 1;
      else if (detectBorda & flag)
        bitsync <= 1;
      else
        bitsync <= 0;
    end
end
  
 // registrador de deslocamento para concatenar em 2 bytes os 16 bits recebidos
 always @(posedge bitsync or posedge reset)
begin
		if(reset)
          begin
			data <= 'd0;
		  end
  		else 
          begin
            data[0] <= bitout;
            data[1] <= data[0];
            data[2] <= data[1];
            data[3] <= data[2];
            data[4] <= data[3];
            data[5] <= data[4];
            data[6] <= data[5];
            data[7] <= data[6];
            data[8] <= data[7];
            data[9] <= data[8];
            data[10] <= data[9];
            data[11] <= data[10];
            data[12] <= data[11];
            data[13] <= data[12];
            data[14] <= data[13];
            data[15] <= data[14];
		  end
end
  

endmodule






