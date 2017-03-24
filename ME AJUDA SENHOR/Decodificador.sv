module Decodificador(
  input logic [7:0]data,
  output logic [7:0]BD_DATA
);

always_comb begin
  BD_DATA[7] <= data[7];
  BD_DATA[6] <= BD_DATA[7] ^ data[6];
  BD_DATA[5] <= BD_DATA[6] ^ data[5];
  BD_DATA[4] <= BD_DATA[5] ^ data[4];
  BD_DATA[3] <= BD_DATA[4] ^ data[3];
  BD_DATA[2] <= BD_DATA[3] ^ data[2];
  BD_DATA[1] <= BD_DATA[2] ^ data[1];
  BD_DATA[0] <= BD_DATA[1] ^ data[0];
end

endmodule