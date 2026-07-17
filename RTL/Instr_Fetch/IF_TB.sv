`timescale 1ns / 1ps

module IF_TB();

    //import uvm_pkg::*;
    //`include "uvm_macros.svh"

    //Input to IF
    reg clk, rstn;
    reg is_ctrl_flow, is_compressed_instr;
    reg [63:0] target_addr;
    
    //Output from IF
    wire [63:0] current_pc, next_pc;
    
    //DUT Instantiation
    IF DUT(
        .clk(clk), .rstn(rstn),
        .is_ctrl_flow(is_ctrl_flow), .is_compressed_instr(is_compressed_instr),
        .target_addr(target_addr),
        .current_pc(current_pc), .next_pc(next_pc) );
    
    //Clk generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 1;
        @(posedge clk) rstn = 1'b 0;
        repeat (2) @(posedge clk);
        rstn = 1'b 1;
        target_addr = 64'd 0;
        is_ctrl_flow = 1'b 0;
        is_compressed_instr = 1'b 0;
    end
    
    initial begin
        repeat (10) @(posedge clk);
        for (int i = 0; i < 20; i++) begin
            @(posedge clk)
            target_addr = {$urandom(), $urandom()};
            {is_ctrl_flow, is_compressed_instr} = $urandom();
        end
        @(posedge clk)
        target_addr = 64'd 0;
        is_ctrl_flow = 1'b 0;
        is_compressed_instr = 1'b 0;
    end
    
    initial begin
        repeat (40) @(posedge clk);
        $finish;
    end

endmodule
`timescale 1ns / 1ps

module IF_TB();

    //import uvm_pkg::*;
    //`include "uvm_macros.svh"

    //Input to IF
    reg clk, rstn;
    reg is_ctrl_flow, is_compressed_instr;
    reg [63:0] target_addr;
    
    //Output from IF
    wire [63:0] current_pc, next_pc;
    
    //DUT Instantiation
    IF DUT(
        .clk(clk), .rstn(rstn),
        .is_ctrl_flow(is_ctrl_flow), .is_compressed_instr(is_compressed_instr),
        .target_addr(target_addr),
        .current_pc(current_pc), .next_pc(next_pc) );
    
    //Clk generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 1;
        @(posedge clk) rstn = 1'b 0;
        repeat (2) @(posedge clk);
        rstn = 1'b 1;
    end
    
    initial begin
        is_compressed_instr = 1'b 0;
        is_ctrl_flow = 1'b 0;
        target_addr = 64'd 10;
    end
    
    initial begin
        repeat (20) @(posedge clk);
        $finish;
    end

endmodule
