module RegisterField(
	input logic [7:0] DATA_IN,
	input logic [7:0] ADDRESS_IN,
	output logic [7:0] ADDRESS_OUT,
	output logic [7:0] DATA_OUT,
	input logic write_enable,
	input logic clk,
	input logic rst
);

logic [7:0]BD_CONTROL;
logic [7:0]BD_DATA_0;
logic [7:0]BD_DATA_1;

always_ff @(negedge clk or posedge rst) begin
	if(rst) begin
		ADDRESS_OUT <= 0;
		DATA_OUT <= 0;
		BD_CONTROL <= 0;
		BD_DATA_0 <= 0;
		BD_DATA_1 <= 0;
	end
	else if(write_enable) begin
		case(ADDRESS_IN)
			48: BD_CONTROL <= DATA_IN;
			49: BD_DATA_0 <= DATA_IN;
			50: BD_DATA_1 <= DATA_IN;
			default: begin 
			BD_CONTROL <= BD_CONTROL;
			BD_DATA_0 <= BD_DATA_0;
			BD_DATA_1 <= BD_DATA_1;
			end
		endcase
	end
	else begin
		case(ADDRESS_IN)
			48: DATA_OUT <= BD_CONTROL;
			49: DATA_OUT <= BD_DATA_0;
			50: DATA_OUT <= BD_DATA_1;
			default:	DATA_OUT <= DATA_OUT;
		endcase
	end
	ADDRESS_OUT <= ADDRESS_IN;
end

endmodule