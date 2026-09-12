module IF
#(
	parameter boot_addr = 64'd 0
)
(
	input             IF_clk, IF_rstn,
	input             is_ctrl_true_i,
	input      [63:0] branch_addr_i,
	input      [31:0] fetched_instr_i,
	input             instr_valid_IF,
	output   	  instr_ready_IF,
	output reg [63:0] current_pc_o,
	output  	  pc_valid,
	input             pc_ready
);

/* TO-DO */
//1. Register the instruction fetched outside of pipeline - preferably in the top pipeline module
//2. Check control path for jump and branch instructions in IF stage
/* ------ */

typedef enum {
	PC_RST,
	PC_VALID,
	PC_INSTR_FETCH,
	PC_INCR
} pc_state;

pc_state next_pc_state, current_pc_state;

reg [63:0] next_pc;

assign instr_ready_IF = current_pc_state == PC_INSTR_FETCH;
assign pc_valid    = current_pc_state == PC_VALID;

always_ff @ (posedge IF_clk) begin
	if (IF_rstn == 1'b 0) begin
		current_pc_o     <= boot_addr;
		current_pc_state <= PC_RST;
	end
	else begin
		current_pc_o     <= next_pc;
		current_pc_state <= next_pc_state;
	end
end

always_comb begin
	next_pc_state = current_pc_state;
	next_pc       = current_pc_o;
	case (current_pc_state)
		PC_RST         : begin
			next_pc_state = PC_VALID;
			next_pc       = boot_addr;
		end
		PC_VALID       : begin
			if (pc_ready == 1'b 1) begin
				next_pc_state = PC_INSTR_FETCH;
			end
			else begin
				next_pc_state = PC_VALID;
			end
		end
		PC_INSTR_FETCH : begin
			if (instr_valid_IF == 1'b 1) begin
				next_pc_state = PC_INCR;
			end
			else begin
				next_pc_state = PC_INSTR_FETCH;	
			end
		end
		PC_INCR        : begin
			next_pc_state = PC_VALID;
			if (is_ctrl_true_i == 1'b 0) begin
				if (fetched_instr_i[1:0] != 2'b 11) begin
					next_pc = current_pc_o + 64'h 2;
			 	end	
		  		else begin
					next_pc = current_pc_o + 64'h 4;
				end
			end
			else begin
				next_pc = branch_addr_i;
			end
		end
	endcase
end

endmodule
