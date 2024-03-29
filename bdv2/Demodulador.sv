module Demodulador(
  input logic G_CLK_RX,
  
  input logic  [7:0]in_signal,
  //input logic signal,
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
logic [7:0] buffer_3;  
logic  [7:0]in_signal;
  
logic ff1, ff2;
  logic [7:0] test_cont;
logic [7:0] contador;

logic detectBorda;
  
 /*********************************************************************************************************************************/ 
 // Apenas para testes
  /*
  always_comb //@(posedge G_CLK_RX or posedge reset) 
  begin
    if (reset) 
      in_signal <= 8'd128;
    else
      begin
        case (test_cont)
        	8'd0: in_signal <= 8'd128;
            8'd1: in_signal <= 8'd153;
            8'd2: in_signal <= 8'd177;
            8'd3: in_signal <= 8'd199;
            8'd4: in_signal <= 8'd218;
            8'd5: in_signal <= 8'd234;
            8'd6: in_signal <= 8'd246;
            8'd7: in_signal <= 8'd253;
            8'd8: in_signal <= 8'd255;
            8'd9: in_signal <= 8'd253;
            8'd10: in_signal <= 8'd246;
            8'd11: in_signal <= 8'd234;
            8'd12: in_signal <= 8'd218;
            8'd13: in_signal <= 8'd199;
            8'd14: in_signal <= 8'd177;
            8'd15: in_signal <= 8'd153;
            8'd16: in_signal <= 8'd128;
            8'd17: in_signal <= 8'd103;
            8'd18: in_signal <= 8'd79;
            8'd19: in_signal <= 8'd57;
            8'd20: in_signal <= 8'd38;
            8'd21: in_signal <= 8'd22;
            8'd22: in_signal <= 8'd10;
            8'd23: in_signal <= 8'd3;
            8'd24: in_signal <= 8'd1;
            8'd25: in_signal <= 8'd3;
            8'd26: in_signal <= 8'd10;
            8'd27: in_signal <= 8'd22;
            8'd28: in_signal <= 8'd38;
            8'd29: in_signal <= 8'd57;
            8'd30: in_signal <= 8'd79;
            8'd31: in_signal <= 8'd103;
        endcase
      end
  end
  */

/********************************************************************************************************************************/

  
// Grampeador 
  
always_comb //@(posedge G_CLK_RX or posedge reset) 
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
        buffer_3 <= 0;
     end 
   else
     begin
     	buffer_1 <= in_signal;
        buffer_2 <= buffer_1;
        buffer_3 <= buffer_2;
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
       if ((buffer_1 == buffer_2) && (buffer_2 == buffer_3))
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
  
always @(posedge G_CLK_RX or posedge reset)
begin
  if (reset)
    begin
    	test_cont <= 8'd0;
    end
  else    
  	begin
      if (test_cont > 31)
      	test_cont <= 0;
      else
        test_cont <= test_cont + 1;
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






