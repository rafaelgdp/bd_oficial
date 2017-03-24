module RegisterField(
	input logic [7:0] DATA_IN,
	input logic [7:0] ADDRESS_IN,
	output logic [7:0] ADDRESS_OUT,
	output logic [7:0] DATA_OUT,
	input logic write_enable,
	input logic clk,
	input logic rst
);

logic [7:0]data1;
logic [7:0]data2;
logic [7:0]data3;

always_ff @(negedge clk or posedge rst) begin
	if(rst) begin
		ADDRESS_OUT <= 0;
		DATA_OUT <= 0;
		data1 <= 0;
		data2 <= 0;
		data3 <= 0;
	end
	else if(write_enable) begin
		case(ADDRESS_IN)
			48: data1 <= DATA_IN;
			49: data2 <= DATA_IN;
			50: data3 <= DATA_IN;
			default: begin 
			data1 <= data1;
			data2 <= data2;
			data3 <= data3;
			end
		endcase
	end
	else begin
		case(ADDRESS_IN)
			48: DATA_OUT <= data1;
			49: DATA_OUT <= data2;
			50: DATA_OUT <= data3;
			default:	DATA_OUT <= DATA_OUT;
		endcase
	end
	ADDRESS_OUT <= ADDRESS_IN;
end

endmodule