module RegFile_32x64(
    clk, rstn,
    reg_addr1, reg_addr2,
    wr_en,
    rd_en1, rd_en2,
    wdata,
    rdata1, rdata2
);
    
    //Inputs
    input clk, rstn;
    input [4:0] reg_addr1, reg_addr2;
    input wr_en;
    input rd_en1, rd_en2;
    input [63:0] wdata;
    
    //Outputs
    output wire [63:0] rdata1, rdata2;
    
    //Reg declarations
    reg [63:0] reg_array [32];
    reg [63:0] tmp_rdata1, tmp_rdata2;
    
    //Register File Logic
    always @ (posedge clk) begin
        if (rstn == 1'b 0) begin
            for (reg [5:0] i = 6'd 0; i <= 6'd 31; i++) begin
                reg_array [i] <= 64'd 0;
            end
        end
        else begin
            case ({wr_en, rd_en1, rd_en2})
                3'b 100: begin
                    if (reg_addr1 != 5'd 0) begin
                        reg_array[reg_addr1] <= wdata;
                    end
                end
                3'b 010: begin
                    tmp_rdata1 <= reg_array[reg_addr1];
                end
                3'b 001: begin
                    tmp_rdata2 <= reg_array[reg_addr2];
                end
                3'b 011: begin
                    tmp_rdata1 <= reg_array[reg_addr1];
                    tmp_rdata2 <= reg_array[reg_addr2];
                end
                default: begin
                    tmp_rdata1 <= tmp_rdata1;
                    tmp_rdata2 <= tmp_rdata2;
                end
            endcase
        end
    end
    
    assign rdata1 = (reg_addr1 == 5'd 0 && rd_en1) ? 64'd 0 : tmp_rdata1;
    assign rdata2 = (reg_addr2 == 5'd 0 && rd_en2) ? 64'd 0 : tmp_rdata2;
    
endmodule
