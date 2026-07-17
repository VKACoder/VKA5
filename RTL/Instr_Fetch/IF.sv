module IF
#(
    parameter [63:0] boot_addr = 64'd 0 //Reset boot address
)
(
    clk, rstn,
    is_ctrl_flow, is_compressed_instr,
    target_addr,
    current_pc, next_pc
    
);

    //Inputs
    input clk, rstn;
    input is_ctrl_flow, is_compressed_instr;
    input [63:0] target_addr;
    
    //Outputs
    output reg [63:0] current_pc;
    output reg [63:0] next_pc;

    always_comb begin : next_pc_logic
        if (rstn == 1'b 0) begin
            next_pc = boot_addr;
        end
        else begin
            if (is_compressed_instr)
                next_pc = current_pc + 64'h 2;
            else
                next_pc = current_pc + 64'h 4; 
        end
    end

    always_ff @ (posedge clk) begin : current_pc_logic
        if (rstn == 1'b 0) begin
            current_pc <= boot_addr;
        end
        else begin
            if (is_ctrl_flow) begin
                current_pc <= target_addr;
            end
            else begin
                current_pc <= next_pc;
            end
        end
    end

endmodule
