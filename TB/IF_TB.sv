module IF_TB ();

//Inputs to IF
reg        IF_clk, IF_rstn;
reg        is_ctrl_true_o;
reg [63:0] branch_addr_o;
reg [31:0] fetched_instr_o;
reg        instr_valid;
reg        pc_ready;

//Output from IF
wire 	    instr_ready;
wire [63:0] current_pc_i;
wire	    pc_valid;

int random_value;

always #5 IF_clk = ~IF_clk;

IF IF_DUT
(
	.IF_clk(IF_clk), .IF_rstn(IF_rstn),
	.is_ctrl_true_i(is_ctrl_true_o),
	.branch_addr_i(branch_addr_o),
	.fetched_instr_i(fetched_instr_o),
	.instr_valid(instr_valid),
	.instr_ready(instr_ready),
	.current_pc_o(current_pc_i),
	.pc_valid(pc_valid),
	.pc_ready(pc_ready)
);

initial begin
	IF_clk             = 1'b 0;
	IF_rstn            = 1'b 0;

	instr_valid     = 1'b 0;
	pc_ready        = 1'b 0;

	is_ctrl_true_o  = 1'b 0;
	branch_addr_o   = 64'h 0;
	fetched_instr_o = 32'h 0;

	repeat (5) @(posedge IF_clk);

	@(negedge IF_clk);
	IF_rstn		= 1'b 1;

	for (int i = 0; i < 30; i = i + 1) begin

		@(negedge IF_clk);

		pc_ready         = 1'b 1;
		wait (pc_valid == 1'b 1);

		@(posedge IF_clk);

		@(negedge IF_clk);
		pc_ready         = 1'b 0;

		fetched_instr_o      = $urandom();

		random_value     = $urandom_range(10,1);
		repeat (random_value) @(posedge IF_clk);

		@(negedge IF_clk);

		instr_valid      = 1'b 1;
		/* verilator lint_off WIDTH */
		is_ctrl_true_o   = $urandom_range(1, 0); 
		/* verilator lint_on WIDTH */
		branch_addr_o    = {$urandom(), $urandom()};

		wait (instr_ready == 1'b 1);

		@(posedge IF_clk);

		@(negedge IF_clk);
		instr_valid      = 1'b 0;
	end

	repeat(2) @(posedge IF_clk);
	$finish();
end

initial begin
	repeat (10*10000) @(posedge IF_clk);
	$fatal("Watchdog timeout");
end

initial begin
	$dumpfile("dump.vcd");
	$dumpvars(0, IF_TB);
end

endmodule
