module Decodificador(
  input logic [7:0]data,
  output logic [7:0]BD_DATA,
);

always_comb begin
  BD_DATA[15] <= data[15];
  BD_DATA[14] <= BD_DATA[15] ^ data[14];
  BD_DATA[13] <= BD_DATA[14] ^ data[13];
  BD_DATA[12] <= BD_DATA[13] ^ data[12];
  BD_DATA[11] <= BD_DATA[12] ^ data[11];
  BD_DATA[10] <= BD_DATA[11] ^ data[10];
  BD_DATA[9] <= BD_DATA[10] ^ data[9];
  BD_DATA[8] <= BD_DATA[9] ^ data[8];
  BD_DATA[7] <= BD_DATA[8] ^ data[7];
  BD_DATA[6] <= BD_DATA[7] ^ data[6];
  BD_DATA[5] <= BD_DATA[6] ^ data[5];
  BD_DATA[4] <= BD_DATA[5] ^ data[4];
  BD_DATA[3] <= BD_DATA[4] ^ data[3];
  BD_DATA[2] <= BD_DATA[3] ^ data[2];
  BD_DATA[1] <= BD_DATA[2] ^ data[1];
  BD_DATA[0] <= BD_DATA[1] ^ data[0];
end

endmodule
