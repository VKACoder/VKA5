`timescale 1ns / 1ps

module EX_TB();

    import RV64_pkg::*;

    //Inputs to EX
    reg clk, rstn;
    operation op_o;
    reg [63:0] current_pc_o;
    reg [63:0] rdata1_o, rdata2_o, imm_value_o;
    
    //Outputs from EX
    wire [63:0] alu_result_i;
    wire branch_taken_i;
    wire [63:0] target_addr_i;
    wire [6:0] is_load_type_i;
    wire [3:0] is_store_type_i;
    
    EX DUT(
        .clk(clk), .rstn(rstn),
        .op_i(op_o),
        .current_pc_i(current_pc_o),
        .rdata1_i(rdata1_o), .rdata2_i(rdata2_o), .imm_value_i(imm_value_o),
        .alu_result_o(alu_result_i),
        .branch_taken_o(branch_taken_i),
        .target_addr_o(target_addr_i),
        .is_load_type_o(is_load_type_i), .is_store_type_o(is_store_type_i) );
        
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 0;
        current_pc_o = -64'd 1;
        op_o = '0;
        repeat (2) @(posedge clk);
        rstn = 1'b 1;
    end
    
    initial begin
        wait (rstn == 1'b 1);
        for (int i = 0; i < 50; i++) begin
            current_pc_o = current_pc_o + 1'b 1;
            @(posedge clk) op_o = operation'(1'b 1 << i);
            rdata1_o     = {$urandom(), $urandom()};
            rdata2_o     = {$urandom(), $urandom()};
            imm_value_o  = {$urandom(), $urandom()};
        end
        #5 $finish();
    end

endmodule
