module Decodificador(
  input logic [7:0]data,
  output logic [7:0]BD_DATA_X
);

always_comb begin
  BD_DATA_X[7] <= data[7];
  BD_DATA_X[6] <= BD_DATA_X[7] ^ data[6];
  BD_DATA_X[5] <= BD_DATA_X[6] ^ data[5];
  BD_DATA_X[4] <= BD_DATA_X[5] ^ data[4];
  BD_DATA_X[3] <= BD_DATA_X[4] ^ data[3];
  BD_DATA_X[2] <= BD_DATA_X[3] ^ data[2];
  BD_DATA_X[1] <= BD_DATA_X[2] ^ data[1];
  BD_DATA_X[0] <= BD_DATA_X[1] ^ data[0];
end

endmodule
