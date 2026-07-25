`timescale 1ns / 1ps

module ID_TB();

    //import uvm_pkg::*;
    //`include "uvm_macros.svh"
    import RV64_pkg::*;

    //Inputs to ID
    reg clk, rstn;
    reg [31:0] instr_fetched_o;
    reg [63:0] current_pc_o;
    
    //Outputs from ID
    wire is_compressed_instr_i, is_valid_instr_i;
    wire rd_en1, rd_en2, imm_valid;
    wire [4:0] reg_addr1, reg_addr2;
    wire [63:0] imm_value_i;
    wire [63:0] current_pc_i;
    operation op_i;

    //Reg declarations
    reg [63:0] pc;
    reg wait_rstn;

    //DUT Instantiation
    ID DUT(
        .clk(clk), .rstn(rstn),
        .instr_fetched_i(instr_fetched_o),
        .current_pc_i(current_pc_o),
        .is_compressed_instr_o(is_compressed_instr_i), .is_valid_instr_o(is_valid_instr_i),
        .rd_en1(rd_en1), .rd_en2(rd_en2), .imm_valid(imm_valid),
        .reg_addr1(reg_addr1), .reg_addr2(reg_addr2),
        .imm_value_i(imm_value_o), 
        .current_pc_i(current_pc_o),
        .op_o(op_i) );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b 0;
        rstn = 1'b 1;
        wait_rstn = 1'b 0;
        current_pc_o = 64'd 0;
        instr_fetched_o = 32'd 0;
        @ (posedge clk) rstn = 1'b 0;
        repeat (2) @ (posedge clk)
        @ (posedge clk) rstn = 1'b 1; 
        #2 wait_rstn = 1'b 1;
    end
    
    initial begin
        wait (wait_rstn == 1'b 1);
        //============================================================
        // U-Type
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 0000;
        instr_fetched_o = 32'h 100002B7; // lui     x5, 0x10000              (U)  is_lui
        
        @ (posedge clk) current_pc_o = 64'h 0004;
        instr_fetched_o = 32'h 00001317; // auipc   x6, 0x1                  (U)  is_auipc
        
        
        //============================================================
        // J-Type
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 0008;
        instr_fetched_o = 32'h 010000EF; // jal     x1, 16                  (J)  is_jal
        
        
        //============================================================
        // I-Type Arithmetic
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 000C;
        instr_fetched_o = 32'h 00A08113; // addi    x2, x1, 10              is_addi
        
        @ (posedge clk) current_pc_o = 64'h 0010;
        instr_fetched_o = 32'h FFF0A193; // slti    x3, x1, -1              is_slti
        
        @ (posedge clk) current_pc_o = 64'h 0014;
        instr_fetched_o = 32'h 0010B213; // sltiu   x4, x1, 1               is_sltiu
        
        @ (posedge clk) current_pc_o = 64'h 0018;
        instr_fetched_o = 32'h 0FF0C293; // xori    x5, x1, 255             is_xori
        
        @ (posedge clk) current_pc_o = 64'h 001C;
        instr_fetched_o = 32'h 00F0E313; // ori     x6, x1, 15              is_ori
        
        @ (posedge clk) current_pc_o = 64'h 0020;
        instr_fetched_o = 32'h 0F00F393; // andi    x7, x1, 240             is_andi
        
        @ (posedge clk) current_pc_o = 64'h 0024;
        instr_fetched_o = 32'h 00309413; // slli    x8,  x1, 3              is_slli
        
        @ (posedge clk) current_pc_o = 64'h 0028;
        instr_fetched_o = 32'h 0030D493; // srli    x9,  x1, 3              is_srli
        
        @ (posedge clk) current_pc_o = 64'h 002C;
        instr_fetched_o = 32'h 4030D513; // srai    x10, x1, 3              is_srai
        
        @ (posedge clk) current_pc_o = 64'h 0030;
        instr_fetched_o = 32'h 0050859B; // addiw   x11, x1, 5              is_addiw
        
        @ (posedge clk) current_pc_o = 64'h 0034;
        instr_fetched_o = 32'h 0020961B; // slliw   x12, x1, 2              is_slliw
        
        @ (posedge clk) current_pc_o = 64'h 0038;
        instr_fetched_o = 32'h 0020D69B; // srliw   x13, x1, 2              is_srliw
        
        @ (posedge clk) current_pc_o = 64'h 003C;
        instr_fetched_o = 32'h 4020D71B; // sraiw   x14, x1, 2              is_sraiw
        
        
        //============================================================
        // Loads
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 0040;
        instr_fetched_o = 32'h 00008283; // lb      x5,0(x1)                is_lb
        
        @ (posedge clk) current_pc_o = 64'h 0044;
        instr_fetched_o = 32'h 00209303; // lh      x6,2(x1)                is_lh
        
        @ (posedge clk) current_pc_o = 64'h 0048;
        instr_fetched_o = 32'h 0040A383; // lw      x7,4(x1)                is_lw
        
        @ (posedge clk) current_pc_o = 64'h 004C;
        instr_fetched_o = 32'h 0000C403; // lbu     x8,0(x1)                is_lbu
        
        @ (posedge clk) current_pc_o = 64'h 0050;
        instr_fetched_o = 32'h 0020D483; // lhu     x9,2(x1)                is_lhu
        
        @ (posedge clk) current_pc_o = 64'h 0054;
        instr_fetched_o = 32'h 0040E503; // lwu     x10,4(x1)               is_lwu
        
        @ (posedge clk) current_pc_o = 64'h 0058;
        instr_fetched_o = 32'h 0080B583; // ld      x11,8(x1)               is_ld
        
        
        //============================================================
        // Stores
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 005C;
        instr_fetched_o = 32'h 00508023; // sb      x5, 0(x1)               is_sb
        
        @ (posedge clk) current_pc_o = 64'h 0060;
        instr_fetched_o = 32'h 00609123; // sh      x6, 2(x1)               is_sh
        
        @ (posedge clk) current_pc_o = 64'h 0064;
        instr_fetched_o = 32'h 0070A223; // sw      x7, 4(x1)               is_sw
        
        @ (posedge clk) current_pc_o = 64'h 0068;
        instr_fetched_o = 32'h 0080B423; // sd      x8, 8(x1)               is_sd
        
        
        //============================================================
        // Branches
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 006C;
        instr_fetched_o = 32'h 00208863; // beq     x1, x2, 16              is_beq
        
        @ (posedge clk) current_pc_o = 64'h 0070;
        instr_fetched_o = 32'h 00209863; // bne     x1, x2, 16              is_bne
        
        @ (posedge clk) current_pc_o = 64'h 0074;
        instr_fetched_o = 32'h 0020C863; // blt     x1, x2, 16              is_blt
        
        @ (posedge clk) current_pc_o = 64'h 0078;
        instr_fetched_o = 32'h 0020D863; // bge     x1, x2, 16              is_bge
        
        @ (posedge clk) current_pc_o = 64'h 007C;
        instr_fetched_o = 32'h 0020E863; // bltu    x1, x2, 16              is_bltu
        
        @ (posedge clk) current_pc_o = 64'h 0080;
        instr_fetched_o = 32'h 0020F863; // bgeu    x1, x2, 16              is_bgeu
        
        
        //============================================================
        // R-Type
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 0084;
        instr_fetched_o = 32'h 002081B3; // add     x3,x1,x2                is_add
        
        @ (posedge clk) current_pc_o = 64'h 0088;
        instr_fetched_o = 32'h 40208233; // sub     x4,x1,x2                is_sub
        
        @ (posedge clk) current_pc_o = 64'h 008C;
        instr_fetched_o = 32'h 002092B3; // sll     x5,x1,x2                is_sll
        
        @ (posedge clk) current_pc_o = 64'h 0090;
        instr_fetched_o = 32'h 0020A333; // slt     x6,x1,x2                is_slt
        
        @ (posedge clk) current_pc_o = 64'h 0094;
        instr_fetched_o = 32'h 0020B3B3; // sltu    x7,x1,x2                is_sltu
        
        @ (posedge clk) current_pc_o = 64'h 0098;
        instr_fetched_o = 32'h 0020C433; // xor     x8,x1,x2                is_xor
        
        @ (posedge clk) current_pc_o = 64'h 009C;
        instr_fetched_o = 32'h 0020D4B3; // srl     x9,x1,x2                is_srl
        
        @ (posedge clk) current_pc_o = 64'h 00A0;
        instr_fetched_o = 32'h 4020D533; // sra     x10,x1,x2               is_sra
        
        @ (posedge clk) current_pc_o = 64'h 00A4;
        instr_fetched_o = 32'h 0020E5B3; // or      x11,x1,x2               is_or
        
        @ (posedge clk) current_pc_o = 64'h 00A8;
        instr_fetched_o = 32'h 0020F633; // and     x12,x1,x2               is_and
        
        
        //============================================================
        // RV64 R-Type (OP-32)
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 00AC;
        instr_fetched_o = 32'h 002086BB; // addw    x13, x1, x2             is_addw
        
        @ (posedge clk) current_pc_o = 64'h 00B0;
        instr_fetched_o = 32'h 4020873B; // subw    x14, x1, x2             is_subw
        
        @ (posedge clk) current_pc_o = 64'h 00B4;
        instr_fetched_o = 32'h 002097BB; // sllw    x15, x1, x2             is_sllw
        
        @ (posedge clk) current_pc_o = 64'h 00B8;
        instr_fetched_o = 32'h 0020D83B; // srlw    x16, x1, x2             is_srlw
        
        @ (posedge clk) current_pc_o = 64'h 00BC;
        instr_fetched_o = 32'h 4020D8BB; // sraw    x17, x1, x2             is_sraw
        
        
        //============================================================
        // I-Type Jump
        //============================================================
        
        @ (posedge clk) current_pc_o = 64'h 00C0;
        instr_fetched_o = 32'h 00C100E7; // jalr    x1, x2, 12              is_jalr
        
        repeat (5) @(posedge clk);
        $finish();
    end

endmodule
