module IF
#(
    parameter [63:0] boot_addr = 64'd 0 //Reset boot address
)
(
    clk, rstn,
    is_ctrl_flow_i, is_compressed_instr_i,
    target_addr_i,
    current_pc_o
    
);

    //Inputs
    input clk, rstn;
    input is_ctrl_flow_i, is_compressed_instr_i;
    input [63:0] target_addr_i;
    
    //Outputs
    output reg [63:0] current_pc_o;
    
    //Reg declaration
    reg [63:0] next_pc;

    always_comb begin : next_pc_logic
        if (rstn == 1'b 0) begin
            next_pc = boot_addr;
        end
        else begin
            if (is_compressed_instr_i)
                next_pc = current_pc_o + 64'h 2;
            else
                next_pc = current_pc_o + 64'h 4; 
        end
    end

    always_ff @ (posedge clk) begin : current_pc_logic
        if (rstn == 1'b 0) begin
            current_pc_o <= boot_addr;
        end
        else begin
            if (is_ctrl_flow_i) begin
                current_pc_o <= target_addr_i;
            end
            else begin
                current_pc_o <= next_pc;
            end
        end
    end

endmodule
