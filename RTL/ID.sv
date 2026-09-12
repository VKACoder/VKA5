module ID
(
	input                 ID_clk, ID_rstn,
	input  [31:0]         fetched_instr_i,
	input                 instr_valid_ID,
	output		      instr_ready_ID,
	output instr_metadata instr_metadata_o,
	output operation      op_o	
);

import RV64_pkg::*;

/* TO-DO */
//1. Add functions for ID_DECODE state operation

typedef enum {
	ID_RST,
	ID_INSTR,
	ID_DECODE
} id_state;

typedef struct packed {
	is_R_type, is_I_type,
	is_S_type, is_B_type,
	is_U_type, is_J_type
} op_type;

id_state next_id_state, current_id_state;
op_type  op_type_q;

assign instr_ready = current_id_state == ID_INSTR;

always_ff @ (posedge ID_clk) begin
	if (rstn == 1'b 0) begin
		current_id_state <= ID_RST;
	end
	else begin
		current_id_state <= next_id_state;
	end
end

always_comb begin
	next_id_state = current_id_state;
	case (current_id_state)
		ID_RST: begin
			next_id_state = ID_INSTR;
		end
		ID_INSTR: begin
			if (instr_valid_ID == 1'b 1) begin
				next_id_state = ID_DECODE;
			end
			else begin
				next_id_state = ID_INSTR;
			end
		end
		ID_DECODE: begin
			next_id_state = ID_INSTR;
		end
	endcase
end

always_comb begin
	instr_metadata_o = '0;
	op_o		 = '0;
	if (current_pc_state == ID_DECODE) begin
		
	end
end

endmodule
