import RV64_pkg::*;

module Top_Core(
    clk, rstn,
    instr_fetched_i,
    instr_fetched_valid,
    pc_o
    );
    
    //Inputs
    input clk, rstn;
    input [31:0] instr_fetched_i;
    input instr_fetched_valid;
    
    //Outputs
    output [63:0] pc_o;
    
    //Reg declarations
    //IF/ID pipeline registers
    reg [63:0] IF_current_pc;
    reg [63:0] IF_instr;
    
    //ID/EX pipeline registers
    operation ID_op;
    reg [63:0] ID_current_pc;
    reg [4:0] ID_rd_value;
    reg [63:0] ID_rdata1, ID_rdata2, ID_imm_value;
    
    //Wire declarations
    //ID Stage
    wire [63:0] rdata1, rdata2;
    wire is_valid_instr_i;
    wire imm_value;
    
    
    //Pipeline stages
    IF IF_Stage(
        .clk(clk), .rstn(rstn),
        .is_ctrl_flow_i(1'b 0), .is_compressed_instr_i(is_compressed_instr_i),
        .target_addr_i(64'd 0),
        .current_pc_o(pc_o) );
        
   ID ID_Stage(
        .clk(clk), .rstn(rstn),
        .instr_fetched_i(IF_instr),
        .current_pc_i(IF_current_pc),
        .is_compressed_instr_o(is_compressed_instr_i), .is_valid_instr_o(is_valid_instr_i),
        .rd_en1(rd_en1), .rd_en2(rd_en2), .imm_valid(imm_valid),
        .reg_addr1(reg_addr1), .reg_addr2(reg_addr2),
        .imm_value_o(imm_value), 
        .current_pc_i(current_pc_o),
        .op_o(op_i) );
        
   RegFile_32x64 RegFile(.clk(clk), .rstn(rstn),
                     .reg_addr1(reg_addr1), .reg_addr2(reg_addr2), 
                     .wr_en(1'b 0), .rd_en1(rd_en1), .rd_en2(rd_en2),
                     .wdata(64'd 0), .rdata1(rdata1), .rdata2(rdata2 ));
    
    
endmodule
