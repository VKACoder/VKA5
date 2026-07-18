module ID(
    clk, rstn,
    instr_fetched,
    current_pc,
    is_valid_compressed_instr,
    is_valid_instr,
    rd_en1, rd_en2, imm_valid,
    reg_addr1, reg_addr2,
    imm_value
);

    //Inputs
    input clk, rstn;
    input [31:0] instr_fetched;
    
    //InOuts
    inout [63:0] current_pc;
    
    //Outputs
    output is_valid_compressed_instr, is_valid_instr;
    output rd_en1, rd_en2, imm_valid;
    output [4:0] reg_addr1, reg_addr2;
    output reg [63:0] imm_value;
    
    //Reg declarations
    
    
    //Wire declarations
    wire is_compressed_instr;
    wire is_R_type, is_I_type, is_S_type, is_B_type, is_U_type, is_J_type;
    
    //** ID LOGIC **//
    //Instruction format decoding
    assign is_R_type = rstn == 1'b 0 ? 1'b 0 :
                       ((instr_fetched[6:0] == 7'b 0110011) || 
                       (instr_fetched[6:0] == 7'b 0111011));
                       
    assign is_I_type = rstn == 1'b 0 ? 1'b 0 :
                       ((instr_fetched[6:0] == 7'b 1100111) || 
                       (instr_fetched[6:0] == 7'b 0000011) || 
                       (instr_fetched[6:0] == 7'b 0010011) || 
                       (instr_fetched[6:0] == 7'b 1110011) || 
                       (instr_fetched[6:0] == 7'b 0011011) || 
                       (instr_fetched[6:0] == 7'b 0001111));
                       
    assign is_S_type = rstn == 1'b 0 ? 1'b 0 :
                       (instr_fetched[6:0] == 7'b 0100011);
    
    assign is_B_type = rstn == 1'b 0 ? 1'b 0 :
                       (instr_fetched[6:0] == 7'b 1100011);
    
    assign is_U_type = rstn == 1'b 0 ? 1'b 0 :
                       ((instr_fetched[6:0] == 7'b 0110111) || 
                       (instr_fetched[6:0] == 0010111));
                       
    assign is_J_type = rstn == 1'b 0 ? 1'b 0 :
                       (instr_fetched[6:0] == 7'b 1101111);
                       
    assign is_valid_instr = is_valid_compressed_instr || 
                            (
                            (is_R_type || is_I_type || is_S_type || is_B_type || is_U_type || is_J_type)
                            );
                       
    //Compressed instruction decoding
    assign is_compressed_instr = rstn == 1'b 0 ? 1'b 0 :
                                 (instr_fetched[1:0] != 2'b 11);
                                 
    assign is_valid_compressed_instr = is_compressed_instr; //To Be Updated
    
    //Immediate value calculation
    assign imm_valid = (is_I_type || is_S_type ||
                        is_B_type || is_U_type ||
                        is_J_type);
                        
    always_comb begin : imm_value_extend
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

endmodule
