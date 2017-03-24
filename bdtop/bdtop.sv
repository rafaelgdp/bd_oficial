module bdtop(
input logic [7:0]ADC,
input logic [7:0]DATA_IN,
output logic [7:0]DATA_OUT,
input logic [7:0]ADDRESS_IN,
input logic reset,
input logic G_CLK_RX,
output logic interrupt,
input logic write_enable
);

logic [7:0]RFdata_out;
logic [7:0]RFaddress_out;
logic bitout;
logic bitsinc;

RegisterField M1(.DATA_IN(DATA_IN),
					  .ADDRESS_IN(ADDRESS_IN),
					  .ADDRESS_OUT(RFaddress_out),
					  .DATA_OUT(RFdata_out),
					  .write_enable(write_enable));

dm M2(.clk(G_CLK_RX),	
		.rst(reset),		
		.signal_in(ADC),	 	
		.bitout(bitout),    
		.bitsinc(bitsinc));				

Data M3(.bitin(bitout),
		  .bitsinc(bitsinc),
		  .data(RFdata_out),
		  .reset(reset)
);

Decodificador M4(.data(RFdata_out),
					  .BD_DATA(DATA_OUT));

endmodule