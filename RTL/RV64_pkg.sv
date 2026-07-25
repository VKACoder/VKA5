package RV64_pkg;

    typedef struct packed {
        logic is_add, is_sub;
        logic is_sll, is_srl, is_sra;
        logic is_slt, is_sltu;
        logic is_xor, is_or, is_and;
        logic is_addw, is_subw;
        logic is_sllw, is_srlw, is_sraw;
        logic is_addi;
        logic is_slti, is_sltiu;
        logic is_xori, is_ori, is_andi;
        logic is_slli, is_srli, is_srai;
        logic is_addiw;
        logic is_slliw, is_srliw, is_sraiw;
        logic is_lb, is_lbu;
        logic is_lh, is_lhu;
        logic is_lw, is_lwu;
        logic is_ld;
        logic is_sb, is_sh;
        logic is_sw, is_sd;
        logic is_beq, is_bne;
        logic is_blt, is_bge;
        logic is_bltu, is_bgeu;
        logic is_jal;
        logic is_jalr;
        logic is_lui;
        logic is_auipc;
        //logic is_fence;
        //logic is_fence_tso;
        //logic is_pause;
        //logic is_ecall;
        //logic is_ebreak;
    } operation;

endpackage
