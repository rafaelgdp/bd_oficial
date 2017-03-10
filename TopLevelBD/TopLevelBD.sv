module TopLevelBD(
  
  //AMBA \/
  output logic ready_in,
  output logic [7:0]data_in,
  input logic valid_in,
  input logic ready_out,
  input logic [7:0]data_out,
  output logic valid_out,
  //AMBA /\
  
  input logic [7:0]ADC,
  input logic G_CLK_RX,
  output logic int_rx_host
);
  

logic [7:0] data_out_dem;
logic [7:0] BD_DATA_X;
  
  Demodulador M1(
    .G_CLK_RX(G_CLK_RX), 
    .ADC(ADC), 
    .int_rx_host(int_rx_host), 
    .data(data_out_dem), 
    .BD_CONTROL(BD_CONTROL)
  );
  
  Decodificador M2(
    .data(data_out_dem),
    .BD_DATA_X(BD_DATA_X)
  );
  
endmodule
