module Decodificador(
  input logic [7:0]data,
  output logic [7:0]BD_DATA,
);

always_comb begin
  BD_DATA_0[15] <= data_0[15];
  BD_DATA_0[14] <= BD_DATA_0[15] ^ data_0[14];
  BD_DATA_0[13] <= BD_DATA_0[14] ^ data_0[13];
  BD_DATA_0[12] <= BD_DATA_0[13] ^ data_0[12];
  BD_DATA_0[11] <= BD_DATA_0[12] ^ data_0[11];
  BD_DATA_0[10] <= BD_DATA_0[11] ^ data_0[10];
  BD_DATA_0[9] <= BD_DATA_0[10] ^ data_0[9];
  BD_DATA_0[8] <= BD_DATA_0[9] ^ data_0[8];
  BD_DATA_0[7] <= BD_DATA_0[8] ^ data_0[7];
  BD_DATA_0[6] <= BD_DATA_0[7] ^ data_0[6];
  BD_DATA_0[5] <= BD_DATA_0[6] ^ data_0[5];
  BD_DATA_0[4] <= BD_DATA_0[5] ^ data_0[4];
  BD_DATA_0[3] <= BD_DATA_0[4] ^ data_0[3];
  BD_DATA_0[2] <= BD_DATA_0[3] ^ data_0[2];
  BD_DATA_0[1] <= BD_DATA_0[2] ^ data_0[1];
  BD_DATA_0[0] <= BD_DATA_0[1] ^ data_0[0];
end

endmodule
