module bdv2 ();
  input logic [7:0]ADC,
  input logic [7:0]DATA_IN,
  input logic [7:0]ADDRESS,
  output logic [7:0]DATA_OUT,
  input logic G_CLK_RX,
  input logic reset,
  input logic write_enabe,
  output logic int_rx_host
);	  
	logic [15:0]data_dm;
	logic status;
	logic RX_ENABLE;
	
	always_comb begin
		if(G_CLK_RX && RX_ENABLE) begin
			Demodulador DM(.G_CLK_RX(G_CLK_RX),
								.in_signal(ADC),
								.reset(reset),
								.status(status),
								.data(data_dm));
			Decodificador DC();
		end
	end
	
	RegisterField RF();
  
endmodule 