module Top_Core
(
    clk, rstn,
    instr_fetched_i,
    instr_fetched_valid_i,
    pc
);

    import RV64_pkg::*;
    
    //Inputs
    input        clk, rstn;
    input [31:0] instr_fetched_i;
    input        instr_fetched_valid_i;
    
    //Outputs
    output [63:0] pc;
    
    //reg declaration
    
    
    //wire declaration
    wire        is_compressed_instr;
    wire        Ctrl_flow;
    wire [63:0] Target_addr;
    wire        Rd_en1, Rd_en2, Imm_valid;
    wire [4:0]  Reg_addr1, Reg_addr2, Rd_addr;
    wire [63:0] Rdata1, Rdata2;
    wire [63:0] Imm_value;
    operation   op;
    wire [63:0] Alu_result;
    wire [6:0]  Is_load;
    wire [3:0]  Is_store;
    
    //Pipeline registers
    //IF/ID Stage
    reg [63:0] IF_current_pc;
    reg [31:0] IF_instr;
     
    //ID/EX Stage
    operation  ID_op;
    reg [63:0] ID_rdata1, ID_rdata2, ID_imm_value;
    reg [63:0] ID_current_pc;
    reg [4:0]  ID_rd;
    
    //Pipeline stage instantiations
    //IF STage
    IF IF_Stage(
        .clk(clk), .rstn(rstn),
        .stall_IF_i(~instr_fetched_valid_i),
        .is_ctrl_flow_i(Ctrl_flow), .is_compressed_instr_i(is_compressed_instr),
        .target_addr_i(Target_addr),
        .current_pc_o(pc) );
        
    //ID Stage
    ID ID_Stage(
        .clk(clk), .rstn(rstn),
        .instr_fetched_i(IF_instr),
        .is_compressed_instr_o(is_compressed_instr), .is_valid_instr_o(/*unconnected*/),
        .rd_en1(Rd_en1), .rd_en2(Rd_en2), .imm_valid(Imm_valid),
        .reg_addr1(Reg_addr1), .reg_addr2(Reg_addr2), .rd_addr(Rd_addr),
        .imm_value_o(Imm_value),
        .op_o(op) );
        
    //EX Stage
    EX EX_Stage(
        .clk(clk), .rstn(rstn),
        .op_i(ID_op),
        .current_pc_i(ID_current_pc),
        .rdata1_i(ID_rdata1), .rdata2_i(ID_rdata2), .imm_value_i(ID_imm_value),
        .alu_result_o(Alu_result),
        .branch_taken_o(Ctrl_flow),
        .target_addr_o(Target_addr),
        .is_load_type_o(Is_load), .is_store_type_o(Is_store) );
    
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
            IF_instr      <= 32'd 0;
        end
        else begin
            IF_current_pc <= pc;
            IF_instr      <= instr_fetched_valid_i == 1'b 1 ? instr_fetched_i : 32'h 00000013;
        end
    end
    
    always_ff @ (posedge clk) begin : ID_EX_Registers
        if (rstn == 1'b 0) begin
            ID_op         <= '0;
            ID_rdata1     <= 64'd 0;
            ID_rdata2     <= 64'd 0;
            ID_imm_value  <= 64'd 0;
            ID_current_pc <= 64'd 0;
            ID_rd         <= 5'd 0;
        end
        else begin
            ID_op         <= op; 
            ID_rdata1     <= Rdata1;
            ID_rdata2     <= Rdata2;
            ID_imm_value  <= Imm_value;   
            ID_current_pc <= IF_current_pc; 
            ID_rd         <= Rd_addr;
        end
    end
    
endmodule