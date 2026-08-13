module EX
(
    clk, rstn,
    op_i,
    current_pc_i,
    rdata1_i, rdata2_i, imm_value_i,
    alu_result_o,
    branch_taken_o,
    target_addr_o,
    is_load_type, is_store_type    
);
    
    import RV64_pkg::*;
    
    //Inputs
    input clk, rstn;
    input operation op_i;
    input [63:0] current_pc_i;
    input [63:0] rdata1_i, rdata2_i, imm_value_i;
    
    //Outputs
    output [63:0] alu_result_o;
    output branch_taken_o;
    output [63:0] target_addr_o;
    output [6:0] is_load_type;
    output [3:0] is_store_type;
    
    //reg declaration
    
    
    //wire declaration
    wire [63:0] slti_result  = (rdata1_i[63] && !imm_value_i[63]) ? 64'd 1 :
                               (!rdata1_i[63] && imm_value_i[63]) ? 64'd 0 :
                               rdata1_i[62:0] < imm_value_i[62:0];  
    wire [63:0] sltiu_result = rdata1_i < imm_value_i;
    
    wire [63:0] slt_result   = (rdata1_i[63] && !rdata2_i[63]) ? 64'd 1 :
                               (!rdata1_i[63] && rdata2_i[63]) ? 64'd 0 :
                               rdata1_i[62:0] < rdata2_i[62:0];
    wire [63:0] sltu_result  = rdata1_i < rdata2_i;
    
    wire [31:0] sllw_result  = rdata1_i[31:0] << rdata2_i[4:0];
    wire [31:0] srlw_result  = rdata1_i[31:0] >> rdata2_i[4:0];
    wire [31:0] sraw_result  = rdata1_i[31:0] >>> rdata2_i[4:0];
    
    wire [31:0] slliw_result  = rdata1_i[31:0] << imm_value_i[4:0];
    wire [31:0] srliw_result  = rdata1_i[31:0] >> imm_value_i[4:0];
    wire [31:0] sraiw_result  = rdata1_i[31:0] >>> imm_value_i[4:0];
    
    wire beq_true  = op_i.is_beq  ? rdata1_i == rdata2_i                   : 1'b 0;
    wire bne_true  = op_i.is_bne  ? rdata1_i != rdata2_i                   : 1'b 0;
    wire bge_true  = op_i.is_bge  ? $signed(rdata1_i) >= $signed(rdata2_i) : 1'b 0;
    wire blt_true  = op_i.is_blt  ? $signed(rdata1_i) < $signed(rdata2_i)  : 1'b 0;
    wire bgeu_true = op_i.is_bgeu ? rdata1_i >= rdata2_i                   : 1'b 0;
    wire bltu_true = op_i.is_bneu ? rdata1_i < rdata2_i                    : 1'b 0;
    
    wire [31:0] addw_result  = rdata1_i[31:0] + rdata2_i[31:0];
    wire [31:0] subw_result  = rdata1_i[31:0] - rdata2_i[31:0];
    wire [31:0] addiw_result = rdata1_i[31:0] + imm_value_i[31:0];
    
    assign branch_taken_o = beq_true || bne_true || bge_true || blt_true || bgeu_true || bltu_true;
    assign target_addr_o  = branch_taken_o ? alu_result : 64'd 0;
    
    assign is_load_type  = {op_i.is_ld, op_i.is_lw, op_i.is_lwu, op_i.is_lh, op_i.lhu, op_i.is_lb, op_i.is_lbu}; 
    assign is_store_type = {op_i.is_sd, op_i.is_sw, op_i.is_sh, op_i.is_sb};
    
    assign alu_result_o = op_i.is_add    ? rdata1_i + rdata2_i                    :
                          op_i.is_sub    ? rdata1_i - rdata2_i                    :
                          op_i.is_sll    ? rdata1_i << rdata2_i[4:0]              :
                          op_i.is_srl    ? rdata1_i >> rdata2_i[4:0]              :
                          op_i.is_sra    ? rdata1_i >>> rdata2_i[4:0]             : 
                          op_i.is_slt    ? slt_result                             :
                          op_i.is_sltu   ? sltu_result                            :
                          op_i.is_and    ? rdata1_i & rdata2_i                    :
                          op_i.is_or     ? rdata1_i | rdata2_i                    :
                          op_i.is_xor    ? rdata1_i ^ rdata2_i                    :
                          op_i.is_addw   ? {{32{addw_result[31]}}, addw_result}   :
                          op_i.is_subw   ? {{32{subw_result[31]}}, subw_result}   :
                          op_i.is_sllw   ? {{32{sllw_result[31]}}, sllw_result}   :
                          op_i.is_srlw   ? {{32{srlw_result[31]}}, srlw_result}   :
                          op_i.is_sraw   ? {{32{sraw_result[31]}}, sraw_result}   :
                          op_i.is_addi   ? rdata1_i + imm_value_i                 :
                          op_i.is_slti   ? slti_result                            :
                          op_i.is_slitu  ? sltiu_result                           :
                          op_i.is_andi   ? rdata1_i & imm_value_i                 :
                          op_i.is_ori    ? rdata1_i | imm_value_i                 :
                          op_i.is_xori   ? rdata1_i ^ imm_value_i                 :
                          op_i.is_slli   ? rdata1_i << imm_value_i[5:0]           :
                          op_i.is_srli   ? rdata1_i >> imm_value_i[5:0]           :
                          op_i.is_srai   ? rdata1_i >>> imm_value_i[5:0]          :
                          op_i.is_addiw  ? {{32{addiw_result[31]}}, addiw_result} :
                          op_i.is_slliw  ? {{32{slliw_result[31]}}, slliw_result} :
                          op_i.is_srliw  ? {{32{srliw_result[31]}}, srliw_result} :
                          op_i.is_sraiw  ? {{32{sraiw_result[31]}}, sraiw_result} :
                          is_load_type   ? rdata1_i + imm_value_i                 :
                          is_store_type  ? rdata1_i + imm_value_i                 :
                          branch_taken_o ? current_pc_i + imm_value_i             : //Single alu result as the expected branch address 
                                                                                    //calculation is same irrespective of the condition
                          op_i.is_jal    ? current_pc_i + imm_value_i             :
                          op_i.is_jalr   ? (rdata1_i + imm_value_i) & ~(64'd 1)   :
                          op_i.is_lui    ? imm_value_i                            :
                          op_i.is_auipc  ? current_pc_i + imm_value_i             :
                          64'd 0;    
    
endmodule