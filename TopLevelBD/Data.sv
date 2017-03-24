module Data(
	input logic bit_in,
	input logic bit_sinc,
	output logic [7:0]data,
	input logic reset
);

logic [2:0]i=0;

always_ff @(posedge bit_sinc or negedge reset) begin
		if(~reset) begin
			i <= 0;
			data <= 0;
		end
		else begin
			data[i] <= bit_in;
			i <= i + 'b1;
		end
end


endmodule