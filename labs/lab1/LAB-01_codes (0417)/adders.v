`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder, gate level modeling
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder, gate level modeling
module FA(output CO, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(CO, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	assign {C3, S} = A+B+C0;
endmodule

//  ripple-carry adder, gate level modeling
//  Do not modify the input/output of module
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);

	// TODO:: Implement gate-level RCA
	wire C1, C2;
    FA FA_0(.CO(C1), .S(S[0]), .A(A[0]), .B(B[0]), .CI(C0));
    FA FA_1(.CO(C2), .S(S[1]), .A(A[1]), .B(B[1]), .CI(C1));
    FA FA_2(.CO(C3), .S(S[2]), .A(A[2]), .B(B[2]), .CI(C2));
	
endmodule

// carry-lookahead adder, gate level modeling
// Do not modify the input/output of module
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);

	// TODO:: Implement gate-level CLA
	wire [2:0] P, G;
    wire nan0, nan1, nan2, nan3;
    wire C1, C2, C3, C4;

    wire C0P0, C0P0P1, C0P0P1P2;
    wire G0P1, G0P1P2;
    wire G1P2;

    AND g0(G[0], A[0], B[0]);
    AND g1(G[1], A[1], B[1]);
    AND g2(G[2], A[2], B[2]);

    OR p0(P[0], A[0], B[0]);
    OR p1(P[1], A[1], B[1]);
    OR p2(P[2], A[2], B[2]);

    AND c0p0(C0P0, C0, P[0]);
    AND c0p0p1(C0P0P1, C0P0, P[1]);
    AND c0p0p1p2(C0P0P1P2, C0P0P1, P[2]);

    AND g0p1(G0P1, G[0], P[1]);
    AND g0p1p2(G0P1P2, G0P1, P[2]);

    AND g1p2(G1P2, G[1], P[2]);

    OR c1(C1, G[0], C0P0);
    OR4 c2(C2, G[1], G[1], G0P1, C0P0P1);
    OR4 c3(C3, G[2], G1P2, G0P1P2, C0P0P1P2);

    FA FA_0(.CO(nan0), .S(S[0]), .A(A[0]), .B(B[0]), .CI(C0));
    FA FA_1(.CO(nan1), .S(S[1]), .A(A[1]), .B(B[1]), .CI(C1));
    FA FA_2(.CO(nan2), .S(S[2]), .A(A[2]), .B(B[2]), .CI(C2));
		
endmodule

`endif
