module imem
#(
    parameter MEM_DEPTH = 1023
)
(
    clk,
    addr_i,
    instr_o,
    instr_valid_o
);
    
    //Inputs
    input clk;
    input [31:0] addr_i;
    
    //Outputs
    output reg [63:0] instr_o;
    output reg instr_valid_o;
    
    logic [7:0] mem [0:MEM_DEPTH-1];
    
    initial begin
        $readmemh("program.mem", mem);
    end
    
    always @ (posedge clk) begin
        instr_o <= {mem[addr_i + 3], mem[addr_i + 2], mem[addr_i + 1], mem[addr_i]};
        instr_valid_o <= 1'b 0;
        repeat (2) @(posedge clk);
        instr_valid_o <= 1'b 1;
    end
    
endmodule
