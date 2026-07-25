`timescale 1ns / 1ps

module IF_TB();

    //import uvm_pkg::*;
    //`include "uvm_macros.svh"

    //Input to IF
    reg clk, rstn;
    reg is_ctrl_flow_o, is_compressed_instr_o;
    reg [63:0] target_addr_o;
    
    //Output from IF
    wire [63:0] current_pc_i;
    
    //DUT Instantiation
    IF DUT(
        .clk(clk), .rstn(rstn),
        .is_ctrl_flow_i(is_ctrl_flow_o), .is_compressed_instr_i(is_compressed_instr_o),
        .target_addr_i(target_addr_o),
        .current_pc_o(current_pc_i) );
    
    //Clk generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 1;
        @(posedge clk) rstn = 1'b 0;
        repeat (2) @(posedge clk);
        rstn = 1'b 1;
        target_addr_o = 64'd 0;
        is_ctrl_flow_o = 1'b 0;
        is_compressed_instr_o = 1'b 0;
    end
    
    initial begin
        repeat (10) @(posedge clk);
        for (int i = 0; i < 20; i++) begin
            @(posedge clk)
            target_addr_o = {$urandom(), $urandom()};
            {is_ctrl_flow_o, is_compressed_instr_o} = $urandom();
        end
        @(posedge clk)
        target_addr_o = 64'd 0;
        is_ctrl_flow_o = 1'b 0;
        is_compressed_instr_o = 1'b 0;
    end
    
    initial begin
        repeat (40) @(posedge clk);
        $finish;
    end

endmodule
