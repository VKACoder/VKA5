module EX
(
    clk, rstn,
    op_i,
    current_pc_i,
    
    branch_taken_o,
    target_addr_o
);
    
    import RV64_pkg::*;
    
    //Inputs
    input clk, rstn;
    input operation op_i;
    input [63:0] current_pc_i;
    
    //Outputs
    output branch_taken_o;
    output [63:0] target_addr_o;
    
    //reg declaration
    
    
    //wire declaration
    
    
    
endmodule
