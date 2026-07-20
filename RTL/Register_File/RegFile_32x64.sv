module RegFile_32x64(
    clk,
    rstn,
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
    output reg [63:0] rdata1, rdata2;
    
    //Register file array declaration
    reg [63:0] reg_array [31:0];
    
    always_comb begin : read_logic
        if (rstn == 1'b 0) begin
            rdata1 = 64'd 0;
            rdata2 = 64'd 0;
        end
        if (rd_en1 == 1'b 1) begin
            if (reg_addr1 != 5'd 0) begin
                rdata1 = reg_array[reg_addr1];
            end
            else begin
                rdata1 = 64'd 0;
            end
        end
        
        if (rd_en2 == 1'b 1) begin
            if (reg_addr2 != 5'd 0) begin
                rdata2 = reg_array[reg_addr2];
            end
            else begin
                rdata2 = 64'd 0;
            end
        end
    end
    
    always_ff @ (posedge clk) begin : reset_write_logic
        if (rstn == 1'b 0) begin
            for (reg [5:0] i = 6'd 0; i < 6'd 32; i++) begin
                reg_array[i] <= 64'd 0;
            end
        end
        else begin
            if (wr_en == 1'b 1) begin
                if (reg_addr1 != 5'd 0) begin
                    reg_array[reg_addr1] <= wdata;
                end
            end
        end
    end
    
endmodule
