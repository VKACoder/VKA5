`timescale 1ns / 1ps

module TopTB_RV64I();

    //import uvm_pkg::*;
    //`include "uvm_macros.svh"
    
    //Input to Top_Core
    reg clk, rstn;
    wire [31:0] instr_fetched;
    wire instr_fetched_valid; 
    
    //Outputs from Top_Core
    wire [63:0] pc;
    
    //reg declarations
    reg clk_m;
    reg [63:0] clk_count;
    
    //wire declarations
    
    
    //DUT Instantiation
    Top_Core DUT(
        .clk(clk), .rstn(rstn),
        .instr_fetched_i(instr_fetched),
        .instr_fetched_valid_i(instr_fetched_valid),
        .pc(pc) );
        
    imem mem(
        .clk(clk_m),
        .addr_i(pc),
        .instr_o(instr_fetched),
        .instr_valid_o(instr_fetched_valid) );
        
    always #5 clk = ~clk;
    always #5 clk_m = ~clk_m;
    
    initial begin
        clk = 1'b 0;
        clk_m = 1'b 0;
        rstn = 1'b 0;
        repeat (2) @(posedge clk);
        rstn = 1'b 1;
        repeat(425) @(posedge clk);
        $finish();
    end
    
    always @ (posedge clk) begin
        if (rstn == 1'b 0) begin
            clk_count <= 64'd 0;  
        end
        else begin
           clk_count <= clk_count + 1'b 1; 
        end
    end

endmodule
