module Decodificador(
  input logic [7:0]data,
  output logic [7:0]BD_DATA,
);

always_comb begin
  BD_DATA_0[7] <= data_0[7];
  BD_DATA_0[6] <= BD_DATA_0[7] ^ data_0[6];
  BD_DATA_0[5] <= BD_DATA_0[6] ^ data_0[5];
  BD_DATA_0[4] <= BD_DATA_0[5] ^ data_0[4];
  BD_DATA_0[3] <= BD_DATA_0[4] ^ data_0[3];
  BD_DATA_0[2] <= BD_DATA_0[3] ^ data_0[2];
  BD_DATA_0[1] <= BD_DATA_0[2] ^ data_0[1];
  BD_DATA_0[0] <= BD_DATA_0[1] ^ data_0[0];
end

endmodule