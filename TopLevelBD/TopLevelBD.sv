module TopLevelBD(
  
  //AMBA \/ //tem q ver melhor esse AMBA ai
  output logic ready_in,
  output logic [7:0]data_in,
  input logic valid_in,
  input logic ready_out,
  input logic [7:0]data_out,
  output logic valid_out,
  //AMBA /\
  
  input logic [7:0]ADC,
  input logic G_CLK_RX,
  input logic reset,
  output logic int_rx_host
);
  

logic [7:0] data_out_dem_0;
logic [7:0] data_out_dem_1;
logic [7:0] address_RF;
logic [7:0] BD_DATA_0;
logic [7:0] BD_DATA_1;
logic [7:0] BD_DATA_0_DECOD;
logic [7:0] BD_DATA_1_DECOD;
  
  Demodulador M1(
    .G_CLK_RX(G_CLK_RX), 
    .ADC(ADC), 
    .int_rx_host(int_rx_host), 
    .DATA_BYTE_0(data_out_dem_0), //saida data_0 jah demodulada
	 .DATA_BYTE_1(data_out_dem_1), //saida data_1 jah demodulada
    .BD_CONTROL_IN(BD_CONTROL),
	 .reset(reset)
  );
  
  Decodificador M2(
    .data_0(data_out_dem_0), //entrada para decodificar data_0
	 .data_1(data_out_dem_1), //entrada para decodificar data_1
    .BD_DATA_0(BD_DATA_0_DECOD), //saida DATA_0 jah decodificada
	 .BD_DATA_1(BD_DATA_1_DECOD), //saida DATA_1 jah decodificada
  );
  
  RegisterField M3(
	 .DATA_0_IN(BD_DATA_0_DECOD), //data_0 pra ser salvo no registrador
	 .DATA_1_IN(BD_DATA_1_DECOD), //data_1 pra ser salvo no registrador
	 .ADDRESS(address_RF), //endereco pra salvar o dado
	 .BD_DATA_0(BD_DATA_0), //saida do dado_0 que estah salvo no registrador
	 .BD_DATA_1(BD_DATA_1), //saida do dado_1 que estah salvo no registrador
  );
  
endmodule
