module synchronizer
#(
    parameter rst_value = 0,
    parameter width     = 1
)
(
    clk, rstn,
    din,
    dout
);

    //Inputs
    input clk, rstn;
    input [width - 1: 0] din;
    
    //Outputs
    output reg [width - 1: 0] dout;
    
    //reg declaration
    reg [width - 1: 0] sync_reg;
    
    always_ff @ (posedge clk) begin
        if (rstn == 1'b 0) begin
            sync_reg <= {width{rst_value}};
            dout     <= {width{rst_value}};
        end
        else begin
            sync_reg <= din;
            dout     <= sync_reg;
        end
    end

endmodule
