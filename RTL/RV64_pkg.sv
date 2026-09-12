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

	typedef struct packed {
		logic        rd_en1, rd_en2, wr_en; //Read/Write
		logic [4:0]  rs1_addr, rs2_addr, rd_addr; //Source/Destination register address
		logic [63:0] rs1_data, rs2_data; //Write data will be in rs1_data field
		logic        imm_valid;
		logic [63:0] imm_value;
	} instr_metadata;

endpackage
