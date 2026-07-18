module ID(
    clk, rstn,
    instr_fetched,
    current_pc,
    is_valid_compressed_instr,
    is_valid_instr
);

    //Inputs
    input clk, rstn;
    input [31:0] instr_fetched;
    
    //InOuts
    inout [63:0] current_pc;
    
    //Outputs
    output is_valid_compressed_instr, is_valid_instr;
    
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

endmodule