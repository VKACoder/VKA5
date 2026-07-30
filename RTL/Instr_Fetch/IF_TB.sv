`timescale 1ns / 1ps

module IF_TB();

    //import uvm_pkg::*;
    //`include "uvm_macros.svh"

    //Input to IF
    reg clk, rstn;
    reg stall_IF_o;
    reg is_ctrl_flow_o, is_compressed_instr_o;
    reg [63:0] target_addr_o;
    
    //Output from IF
    wire [63:0] current_pc_i;
    
    //DUT Instantiation
    IF DUT(
        .clk(clk), .rstn(rstn),
        .stall_IF_i(stall_IF_o),
        .is_ctrl_flow_i(is_ctrl_flow_o), .is_compressed_instr_i(is_compressed_instr_o),
        .target_addr_i(target_addr_o),
        .current_pc_o(current_pc_i) );
    
    //Clk generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 1;
        stall_IF_o = 1'b 0;
        @(posedge clk) rstn = 1'b 0;
        repeat (2) @(posedge clk);
        rstn = 1'b 1;
        target_addr_o = 64'd 0;
        is_ctrl_flow_o = 1'b 0;
        is_compressed_instr_o = 1'b 0;
        
        for (int i = 0; i < 20; i++) begin
            stall_IF_o = 1'b 1;
            @(posedge clk)
            target_addr_o = {$urandom(), $urandom()};
            //{is_ctrl_flow_o, is_compressed_instr_o} = $urandom();
            @(posedge clk);
            stall_IF_o = 1'b 0;
            @(posedge clk);
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
