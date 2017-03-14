module Decodificador(
  input logic [7:0]data_0,
  input logic [7:0]data_1,
  output logic [7:0]BD_DATA_0,
  output logic [7:0]BD_DATA_1
);

always_comb begin
	//1° BYTE
  BD_DATA_0[7] <= data_0[7];
  BD_DATA_0[6] <= BD_DATA_0[7] ^ data_0[6];
  BD_DATA_0[5] <= BD_DATA_0[6] ^ data_0[5];
  BD_DATA_0[4] <= BD_DATA_0[5] ^ data_0[4];
  BD_DATA_0[3] <= BD_DATA_0[4] ^ data_0[3];
  BD_DATA_0[2] <= BD_DATA_0[3] ^ data_0[2];
  BD_DATA_0[1] <= BD_DATA_0[2] ^ data_0[1];
  BD_DATA_0[0] <= BD_DATA_0[1] ^ data_0[0];
  
  //2° BYTE
  BD_DATA_1[7] <= data_1[7];
  BD_DATA_1[6] <= BD_DATA_1[7] ^ data_1[6];
  BD_DATA_1[5] <= BD_DATA_1[6] ^ data_1[5];
  BD_DATA_1[4] <= BD_DATA_1[5] ^ data_1[4];
  BD_DATA_1[3] <= BD_DATA_1[4] ^ data_1[3];
  BD_DATA_1[2] <= BD_DATA_1[3] ^ data_1[2];
  BD_DATA_1[1] <= BD_DATA_1[2] ^ data_1[1];
  BD_DATA_1[0] <= BD_DATA_1[1] ^ data_1[0];
end

endmodule
