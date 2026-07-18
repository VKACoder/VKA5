`timescale 1ns / 1ps

module ID_TB();

    //import uvm_pkg::*;
    //`include "uvm_macros.svh"

    //Inputs to ID
    reg clk, rstn;
    reg [31:0] instr_fetched;
    
    //Inout to/from ID
    wire [63:0] current_pc;
    wire is_valid_compressed_instr, is_valid_instr;
    
    //Outputs from ID


    //Reg declarations
    reg [63:0] pc;
    reg wait_rstn;

    //DUT Instantiation
    ID DUT(
        .clk(clk), .rstn(rstn),
        .instr_fetched(instr_fetched),
        .current_pc(current_pc),
        .is_valid_compressed_instr(is_valid_compressed_instr), .is_valid_instr(is_valid_instr) );
    
    always #5 clk = ~clk;
    
    assign current_pc = pc;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 1;
        wait_rstn = 1'b 0;
        pc = 64'd 0;
        instr_fetched = 32'd 0;
        @ (posedge clk) rstn = 1'b 0;
        repeat (2) @ (posedge clk)
        @ (posedge clk) rstn = 1'b 1; 
        #2 wait_rstn = 1'b 1;
    end
    
    initial begin
        wait (wait_rstn == 1'b 1);
        @ (posedge clk) pc = 64'd 0;
        instr_fetched = 32'h 100002B7; //lui     x5, 0x10000          # x5 = 0x10000000          (U)
        
        @ (posedge clk) pc = 64'h 4;
        instr_fetched = 32'h 00A00313; //addi    x6, x0, 10           # x6 = 10                  (I)
        
        @ (posedge clk) pc = 64'h 8;
        instr_fetched = 32'h 006283B3; //add     x7, x5, x6           # x7 = x5 + x6             (R)
        
        @ (posedge clk) pc = 64'h C; 
        instr_fetched = 32'h 40638433; //sub     x8, x7, x6           # x8 = x7 - x6             (R)
        
        @ (posedge clk) pc = 64'h 10;
        instr_fetched = 32'h 0072B023; //sd      x7, 0(x5)            # MEM[x5] = x7             (S, RV64)
        
        @ (posedge clk) pc = 64'h 14;
        instr_fetched = 32'h 0002B483; //ld      x9, 0(x5)            # x9 = MEM[x5]             (I, RV64)
        
        @ (posedge clk) pc = 64'h 18;
        instr_fetched = 32'h 0054851B; //addiw   x10, x9, 5           # x10 = sext32(x9+5)       (I, RV64)
        
        @ (posedge clk) pc = 64'h 1C;
        instr_fetched = 32'h 006505BB; //addw    x11, x10, x6         # x11 = 32-bit add         (R, RV64)
        
        @ (posedge clk) pc = 64'h 20;
        instr_fetched = 32'h 00A58463; //beq     x11, x10, skip       # branch not taken         (B)
        
        @ (posedge clk) pc = 64'h 24;
        instr_fetched = 32'h 06300613; //addi    x12, x0, 99          # x12 = 99                 (I)
        
        //skip:
        @ (posedge clk) pc = 64'h 28;
        instr_fetched = 32'h 0080006F; //jal     x0, end              # jump                     (J)
        
        @ (posedge clk) pc = 64'h 2C;
        instr_fetched = 32'h 07B00693; //addi    x13, x0, 123         # skipped
        
        //end:
        @ (posedge clk) pc = 64'h 30;
        instr_fetched = 32'h 00700713; //addi    x14, x0, 7           # x14 = 7
        
        @ (posedge clk) pc = 64'h 32;
        instr_fetched = 32'h 0001;     //c.nop                        # no operation
        
        @ (posedge clk) pc = 64'h 34;
        instr_fetched = 32'h 4785;     //c.li    x15, 1               # x15 = 1
        
        @ (posedge clk) pc = 64'h 36;
        instr_fetched = 32'h 0789;     //c.addi  x15, 2               # x15 = x15 + 2 = 3
        
        @ (posedge clk) pc = 64'h 38;
        instr_fetched = 32'h 97BA;     //c.add   x15, x14             # x15 = x15 + x14 = 10
        
        repeat (5) @(posedge clk);
        $finish();
    end

endmodule