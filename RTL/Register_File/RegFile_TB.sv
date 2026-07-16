`timescale 1ns / 1ps

module RegFile_TB;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //Input to RegFile_32x64
    reg clk, rstn;
    reg wr_en, rd_en1, rd_en2;
    reg [4:0] reg_addr1, reg_addr2;
    reg [63:0] wdata;
    
    //Output from RegFile_32x64
    wire [63:0] rdata1, rdata2;
    
    //DUT Instantiation
    RegFile_32x64 DUT(
        .clk(clk), .rstn(rstn),
        .reg_addr1(reg_addr1), .reg_addr2(reg_addr2),
        .wr_en(wr_en),
        .rd_en1(rd_en1), .rd_en2(rd_en2),
        .wdata(wdata),
        .rdata1(rdata1), .rdata2(rdata2) );
    
    //Clk generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 1;
        wr_en = 1'b 0;
        rd_en1 = 1'b 0;
        rd_en2 = 1'b 0;
    end
    
    initial begin
        //Reset
        @(posedge clk) rstn = 1'b 0;
        repeat (2) @(posedge clk);
        @(posedge clk) rstn = 1'b 1;
        
        //Write 1
        @(posedge clk) reg_addr1 = 5'd 31;
        wdata = 64'h AAAA_BBBB_CCCC_DDDD;
        wr_en = 1'b 1;
        @(posedge clk) wr_en = 1'b 0;
        
        //Write 2
        @(posedge clk) reg_addr1 = 5'd 15;
        wdata = 64'h 9999_8888_7777_6666;
        wr_en = 1'b 1;
        @(posedge clk) wr_en = 1'b 0;
        
        //Single Read1 1
        @(posedge clk) reg_addr1 = 5'd 31;
        rd_en1 = 1'b 1;
        @(posedge clk) rd_en1 = 1'b 0;
        
        if (rdata1 != 64'h AAAA_BBBB_CCCC_DDDD) begin
            `uvm_fatal("TB", "RegFile_TB :: Write 1 or Read 1 failed!!");
        end
        
        //Single Read2 2
        @(posedge clk) reg_addr2 = 5'd 15;
        rd_en2 = 1'b 1;
        @(posedge clk) rd_en2 = 1'b 0;
        
        if (rdata2 != 64'h 9999_8888_7777_6666) begin
            `uvm_fatal("TB", "RegFile_TB :: Write 2 or Read 2 failed!!");
        end
                
        //Write 3
        @(posedge clk) reg_addr1 = 5'd 31;
        wdata = 64'h 9999_8888_7777_6666;
        wr_en = 1'b 1;
        @(posedge clk) wr_en = 1'b 0;
        
        //Write 4
        @(posedge clk) reg_addr1 = 5'd 15;
        wdata = 64'h AAAA_BBBB_CCCC_DDDD;
        wr_en = 1'b 1;
        @(posedge clk) wr_en = 1'b 0;
        
        //Dual Read12 3
        @(posedge clk) reg_addr1 = 5'd 31; reg_addr2 = 5'd 15;
        rd_en1 = 1'b 1; rd_en2 = 1'b 1;
        @(posedge clk) rd_en1 = 1'b 0; rd_en2 = 1'b 0;  
        
        if (rdata1 != 64'h 9999_8888_7777_6666 && rdata2 != 64'h AAAA_BBBB_CCCC_DDDD) begin
            `uvm_fatal("TB", "RegFile_TB :: Write 3/4 or Dual Read failed!!");
        end       
        
        //Write 5
        @(posedge clk) reg_addr1 = 5'd 0;
        wdata = 64'h FFFF_FFFF_FFFF_FFFF;
        wr_en = 1'b 1;
        @(posedge clk) wr_en = 1'b 0;
              
        //Single Read1 4
        @(posedge clk) reg_addr1 = 5'd 0;
        rd_en1 = 1'b 1;
        @(posedge clk) rd_en1 = 1'b 0;
        
        if (rdata1 != 64'h 0) begin
            `uvm_fatal("TB", "RegFile_TB :: Write 5 or Read 4 (R0 case) failed!!");
        end
        
        //Single Read2 5
        @(posedge clk) reg_addr2 = 5'd 0;
        rd_en2 = 1'b 1;
        @(posedge clk) rd_en2 = 1'b 0;
        
        if (rdata2 != 64'h 0) begin
            `uvm_fatal("TB", "RegFile_TB :: Write 5 or Read 5 (R0 case) failed!!");
        end
        
        //Dual Read12 6
        @(posedge clk) reg_addr1 = 5'd 0; reg_addr2 = 5'd 0;
        rd_en1 = 1'b 1; rd_en2 = 1'b 1;
        @(posedge clk) rd_en1 = 1'b 0; rd_en2 = 1'b 0; 
        
        if (rdata1 != 64'h 0 && rdata2 != 64'h 0) begin
            `uvm_fatal("TB", "RegFile_TB :: Write 5 or Dual Read (R0 case) failed!!");
        end   
        
        `uvm_info("TB", "RegFile_TB :: Test passed!", UVM_NONE);
    end

endmodule
