import RV64_pkg::*;

module Top_Core(
    clk, rstn,
    instr_fetched,
    instr_fetched_valid,
    pc
    );
    
    //Inputs
    input clk, rstn;
    input [31:0] instr_fetched;
    input instr_fetched_valid;
    
    //Outputs
    output [63:0] pc;
    
    //reg declaration
    
    
    //wire declaration
    wire is_compressed_instr;
    wire Rd_en1, Rd_en2, Imm_valid;
    wire [4:0] Reg_addr1, Reg_addr2;
    wire [63:0] Rdata1, Rdata2;
    wire [63:0] Imm_value;
    wire [63:0] curr_pc_from_ID;
    operarion op;
    
    //Pipeline registers
    //IF/ID Stage
    reg [63:0] IF_current_pc;
    reg [31:0] IF_instr;
     
    //ID/EX Stage
    
    //Pipeline stage instantiations
    //IF STage
    IF IF_Stage(
        .clk(clk), .rstn(rstn),
        .is_ctrl_flow_i(1'b 0), .is_compressed_instr_i(is_compressed_instr),
        .target_addr_i(64'd 0),
        .current_pc_o(pc) );
        
    //ID Stage
    ID ID_Stage(
        .clk(clk), .rstn(rstn),
        .instr_fetched_i(IF_instr),
        .current_pc_i(IF_current_pc),
        .is_compressed_instr_o(is_compressed_instr), .is_valid_instr_o(/*unconnected*/),
        .rd_en1(Rd_en1), .rd_en2(Rd_en2), .imm_valid(Imm_valid),
        .reg_addr1(Reg_addr1), .reg_addr2(Reg_addr2),
        .imm_value_o(Imm_value),
        .current_pc_o(curr_pc_from_ID),
        .op_o(op) );
    
    //Register File
    RegFile_32x64 RegFile(
        .clk(clk), .rstn(rstn),
        .reg_addr1(Reg_addr1), .reg_addr2(Reg_addr2),
        .wr_en(1'b 0), .rd_en1(Rd_en1), .rd_en2(Rd_en2),
        .wdata(64'd 0), .rdata1(Rdata1), .rdata2(Rdata2) );    
    
    //Pipeline Register Updation
    always_ff @ (posedge clk) begin : IF_ID_Registers
        if (rstn == 1'b 0) begin
            IF_current_pc <= 64'd 0;
            IF_instr <= 32'd 0;
        end
        else begin
            IF_current_pc <= pc;
            IF_instr <= instr_fetched_valid == 1'b 1 ? instr_fetched : 32'h 00000013;
        end
    end
    
endmodule
