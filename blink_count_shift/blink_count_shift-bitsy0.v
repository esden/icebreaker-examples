/* Small test design actuating all IO on the iCEBreaker-bitsy dev board. */

module top (
	input  CLK,

	input BTN_N,

	output LEDG_N,
	output LEDR_N,

	output P2,  P3,  P4,  P5,  P6,  P7,  P8,  P9,
	output P10, P11, P17, P18, P19, P20, P21, P22,
	output P23, P24, P32, P34, P36, P38, P40
);

	localparam BITS = 5;
	localparam LOG2DELAY = 20;

	reg [BITS+LOG2DELAY-1:0] counter = 0;
	reg [BITS-1:0] outcnt;

	always @(posedge CLK) begin
		counter <= counter + 1;
		outcnt <= counter >> LOG2DELAY;
	end

	assign LEDG_N = BTN_N;
	assign LEDR_N = ~BTN_N;

	assign {P2,  P3,  P4,  P5,  P6,  P7,  P8, P9,
			P10, P11, P17, P18, P19, P20, P21, P22,
			P23, P24, P32, P34, P36, P38, P40} = 1 << (outcnt % 22);
endmodule

