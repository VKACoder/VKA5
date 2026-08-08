module EX
(
    clk, rstn,
    op_i,
    current_pc_i,
    rdata1_i, rdata2_i, imm_value_i,
    branch_taken_o,
    target_addr_o
);
    
    import RV64_pkg::*;
    
    //Inputs
    input clk, rstn;
    input operation op_i;
    input [63:0] current_pc_i;
    input [63:0] rdata1_i, rdata2_i, imm_value_i;
    
    //Outputs
    output branch_taken_o;
    output [63:0] target_addr_o;
    
    //reg declaration
    
    
    //wire declaration
    wire [63:0] alu_result;
    wire [63:0] slti_result  = (rdata1_i[63] && !imm_value_i[63]) ? 64'd 1 :
                               (!rdata1_i[63] && imm_value_i[63]) ? 64'd 0 :
                               rdata1_i[62:0] < imm_value_i[62:0];  
    wire [63:0] sltiu_result = rdata1_i < imm_value_i;
    
    assign alu_result = (op_i.is_addi)  ? rdata_i + imm_value_i :
                        (op_i.is_slti)  ? stli_result :
                        (op_i.is_slitu) ? sltiu_result :
                        (op_i.is_andi)  ? rdata1_i & imm_vaue_i :
                        (op_i.is_ori)   ? rdata1_i | imm_value_i :
                        (op_i.is_xori)  ? rdata1_i ^ imm_value_i :
                        (op_i.is_slli)  ? rdata1_i << imm_value_i[4:0] :
                        (op_i.is_srli)  ? rdata1_i >> imm_value_i[4:0] :
                        (op_i.is_srai)  ? rdata1_i >>> imm_value_i[4:0] :
                        (op_i.is_lui)   ? imm_value_i :
                        (op_i.is_auipc) ? current_pc_i + imm_value_i : 64'd 0;
    
    
endmodule
