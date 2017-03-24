module Data(
	input logic bitin,
	input logic bitsinc,
	output logic [7:0]data,
	input logic reset
);

always_ff @(posedge bitsinc or posedge reset) begin
		if(reset) begin
			data <= 0;
		end
		else begin
			data[0] = bitin;
			data = data << 1;
		end
end


endmodule