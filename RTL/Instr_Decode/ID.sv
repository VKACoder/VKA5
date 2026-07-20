module ID(
    clk, rstn,
    instr_fetched,
    current_pc,
    is_compressed_instr, /* CHECK */
    is_valid_instr,
    rd_en1, rd_en2, imm_valid,
    reg_addr1, reg_addr2,
    imm_value
);

    typedef struct packed {
        logic is_add, is_sub;
        logic is_sll, is_srl, is_sra;
        logic is_slt, is_sltu;
        logic is_xor, is_or, is_and;
        logic is_addw, is_subw;
        logic is_sllw, is_srlw, is_sraw;
        logic is_addi;
        logic is_slti, is_sltiu;
        logic is_xori, is_ori, is_andi;
        logic is_slli, is_srli, is_srai;
        logic is_addiw;
        logic is_slliw, is_srliw, is_sraiw;
        logic is_lb, is_lbu;
        logic is_lh, is_lhu;
        logic is_lw, is_lwu;
        logic is_ld;
        logic is_sb, is_sh;
        logic is_sw, is_sd;
        logic is_beq, is_bne;
        logic is_blt, is_bge;
        logic is_bltu, is_bgeu;
        logic is_jal;
        logic is_jalr;
        logic is_lui;
        logic is_auipc;
        logic is_fence;
        logic is_fence_tso;
        logic is_pause;
        logic is_ecall;
        logic is_ebreak;
    } operation;

    //Inputs
    input clk, rstn;
    input [31:0] instr_fetched;
    
    //InOuts
    inout [63:0] current_pc;
    
    //Outputs
    output is_compressed_instr /* CHECK */, is_valid_instr;
    output rd_en1, rd_en2, imm_valid;
    output [4:0] reg_addr1, reg_addr2;
    output reg [63:0] imm_value;
    
    //Reg declarations
    reg is_valid_uncompressed_operation;
    
    //Wire declarations
    wire is_valid_compressed_instr, is_valid_uncompressed_instr; /* CHECK */
    wire is_R_type, is_I_type, is_S_type, is_B_type, is_U_type, is_J_type;
    wire is_CR_type, is_CI_type, is_CSS_type, is_CIW_type, is_CL_type, is_CS_type, is_CA_type, is_CB_type, is_CJ_type;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [16:0] uncompressed_dec_bits;
    
    operation op;
         
    //** ID LOGIC **//
    //Uncompressed instructions decoding
    assign is_R_type = ((instr_fetched[6:0] == 7'b 0110011) || (instr_fetched[6:0] == 7'b 0111011));
                       
    assign is_I_type = ((instr_fetched[6:0] == 7'b 1100111) || 
                       (instr_fetched[6:0] == 7'b 0000011) || 
                       (instr_fetched[6:0] == 7'b 0010011) || 
                       (instr_fetched[6:0] == 7'b 1110011) || 
                       (instr_fetched[6:0] == 7'b 0011011) || 
                       (instr_fetched[6:0] == 7'b 0001111));
                       
    assign is_S_type = (instr_fetched[6:0] == 7'b 0100011);
    
    assign is_B_type = (instr_fetched[6:0] == 7'b 1100011);
    
    assign is_U_type = ((instr_fetched[6:0] == 7'b 0110111) || (instr_fetched[6:0] == 0010111));
                       
    assign is_J_type = (instr_fetched[6:0] == 7'b 1101111);
                       
    //opcode, funct3 and funct7 field parsing
    assign opcode = instr_fetched[6:0];
    assign funct3 = instr_fetched[14:12];
    assign funct7 = instr_fetched[31:25];
    
    assign uncompressed_dec_bits = {funct7, funct3, opcode};
                       
    //Compressed instruction decoding
    assign is_compressed_instr = rstn == 1'b 0 ? 1'b 0 :
                                 (instr_fetched[1:0] != 2'b 11);
                                 
    /**
                                 
    assign is_CR_type = ();
    
    assign is_CI_type = ();
    
    assign is_CSS_type = ();
    
    assign is_CIW_type = ();
    
    assign is_CL_type = ();
    
    assign is_CS_type = ();
    
    assign is_CA_type = ();
    
    assign is_CB_type = ();
    
    assign is_CJ_type = ();
    
    **/
                                 
    assign is_valid_compressed_instr = is_compressed_instr /** &&
                                       (is_CR_type || is_CI_type || is_CSS_type || 
                                       is_CIW_type || is_CL_type || is_CS_type ||
                                        is_CA_type || is_CB_type || is_CJ_type) **/;
                                        
    assign is_valid_uncompressed_instr = (is_R_type || is_I_type || is_S_type || is_B_type || is_U_type || is_J_type) && is_valid_uncompressed_operation;
    
    assign is_valid_instr = is_valid_compressed_instr || is_valid_uncompressed_instr;
    
    //Immediate value calculation
    assign imm_valid = (is_I_type || is_S_type ||
                        is_B_type || is_U_type ||
                        is_J_type);
                        
    always_comb begin : imm_value_extension
        case({is_I_type, is_S_type, is_B_type, is_U_type, is_J_type})
            5'b 10000: begin
                imm_value = {{52{instr_fetched[31]}}, instr_fetched[31:20]};
            end
            5'b 01000: begin
                imm_value = {{53{instr_fetched[31]}}, instr_fetched[30:25], instr_fetched[11:7]};            
            end
            5'b 00100: begin
                imm_value = {{52{instr_fetched[31]}}, instr_fetched[7], instr_fetched[30:25], instr_fetched[11:8], 1'b 0};            
            end
            5'b 00010: begin
                imm_value = {{33{instr_fetched[31]}}, instr_fetched[30:12], 12'b 0};            
            end
            5'b 00001: begin
                imm_value = {{44{instr_fetched[31]}}, instr_fetched[19:12], instr_fetched[20], instr_fetched[30:21], 1'b 0};            
            end
            default:   begin
                imm_value = 64'd 0;
            end
        endcase
    end
    
    //SOurce register address and enables
    assign rd_en1 = (is_R_type || is_I_type || is_S_type || is_B_type);
    assign rd_en2 = (is_R_type || is_S_type || is_B_type);
    
    assign reg_addr1 = instr_fetched[19:15];
    assign reg_addr2 = instr_fetched[24:20];
    
    //Operation decoding
    //R-type
    assign op.is_add = uncompressed_dec_bits == {7'd 0, 3'd 0, 7'b 0110011};
    assign op.is_sub = uncompressed_dec_bits == {7'h 20, 3'd 0, 7'b 0110011};
    assign op.is_sll = uncompressed_dec_bits == {7'd 0, 3'd 1, 7'b 0110011};
    assign op.is_slt = uncompressed_dec_bits == {7'd 0, 3'd 2, 7'b 0110011};
    assign op.is_sltu = uncompressed_dec_bits == {7'd 0, 3'd 3, 7'b 0110011};
    assign op.is_xor = uncompressed_dec_bits == {7'd 0, 3'd 4, 7'b 0110011};
    assign op.is_srl = uncompressed_dec_bits == {7'd 0, 3'd 5, 7'b 0110011};
    assign op.is_sra = uncompressed_dec_bits == {7'h 20, 3'd 5, 7'b 0110011};
    assign op.is_or = uncompressed_dec_bits == {7'd 0, 3'd 6, 7'b 0110011};
    assign op.is_and = uncompressed_dec_bits == {7'd 0, 3'd 7, 7'b 0110011};
    
    assign op.is_addw = uncompressed_dec_bits == {7'd 0, 3'd 0, 7'b 0111011};
    assign op.is_subw = uncompressed_dec_bits == {7'h 20, 3'd 0, 7'b 0111011};
    assign op.is_sllw = uncompressed_dec_bits == {7'd 0, 3'd 1, 7'b 0111011};
    assign op.is_srlw = uncompressed_dec_bits == {7'd 0, 3'd 5, 7'b 0111011};
    assign op.is_sraw = uncompressed_dec_bits == {7'h 20, 3'd 5, 7'b 0111011};

endmodule
