`timescale 1ns / 1ps

module ID_TB();

    //import uvm_pkg::*;
    //`include "uvm_macros.svh"

    //Inputs to ID
    reg clk, rstn;
    reg [31:0] instr_fetched;
    
    //Inout to/from ID
    wire [63:0] current_pc;
    
    //Outputs from ID


    //DUT Instantiation
    ID DUT(
        .clk(clk), .rstn(rstn),
        .instr_fetched(instr_fetched),
        .current_pc(current_pc) );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 1;
        @ (posedge clk) rstn = 1'b 0;
        repeat (2) @ (posedge clk)
        @ (posedge clk) rstn = 1'b 1; 
    end

endmodule
