/* Small test design actuating all IO on the iCEBreaker-bitsy dev board. */

module top (
	input  CLK,

	input BTN_N,

	output LEDG_N,

	output P1_1,  P1_2,  P1_3,  P1_4,  P1_7,  P1_8,  P1_9,  P1_10,
	output P2_1,  P2_2,  P2_3,  P2_4,  P2_7,  P2_8,  P2_9,  P2_10,
	output P3_1,  P3_2,  P3_3,  P3_4,  P3_7,  P3_8,  P3_9,  P3_10,
);

	localparam BITS = 5;
	localparam LOG2DELAY = 20;


	reg bp = 0;
	wire bps;
	always @(posedge CLK) begin
		if (BTN_N) begin
			bp <= 0;
			bps <= 0;
		end else begin
			if (bp == 0) begin
				bps <= 1;
				bp <= 1;
			end else begin
				bps <= 0;
			end
		end
	end

	reg [BITS+LOG2DELAY-1:0] counter = 0;
	reg [BITS-1:0] outcnt;
	reg [6:0] shift;
	always @(posedge CLK) begin
		counter <= counter + 1;
		outcnt <= counter >> LOG2DELAY;
		if (bps) begin
			shift <= shift + 1;
		end
	end

	assign LEDG_N = BTN_N;

	assign {P1_1,  P1_2,  P1_3,  P1_4,  P1_7,  P1_8,  P1_9,  P1_10,
		P2_1,  P2_2,  P2_3,  P2_4,  P2_7,  P2_8,  P2_9,  P2_10,
		P3_1,  P3_2,  P3_3,  P3_4,  P3_7,  P3_8,  P3_9,  P3_10} = 1 << (shift % 24);
endmodule
