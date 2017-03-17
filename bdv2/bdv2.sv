module bdv2 ();
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
  
  Demodulador M1();
  
  Decodificador M2();
  
  RegisterField M3();
  
  AMBA amba (.valid(), .data_in(), .address(), .data_out(), .ready());

endmodule 